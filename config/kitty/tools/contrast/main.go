// kitty-contrast reads a kitty theme .conf file and reports the WCAG 2.1
// contrast ratio of the foreground and each ANSI color against the background.
//
// WCAG thresholds (https://www.w3.org/TR/WCAG21/#contrast-minimum):
//   - AA  normal text: 4.5:1
//   - AA  large text:  3.0:1
//   - AAA normal text: 7.0:1
package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"sort"
	"strconv"
	"strings"
)

// --- Pure layer -------------------------------------------------------------

type rgb struct{ r, g, b float64 } // each channel 0..255

// parseHex turns "#rrggbb" into an rgb. Returns ok=false on malformed input.
func parseHex(s string) (rgb, bool) {
	s = strings.TrimPrefix(strings.TrimSpace(s), "#")
	if len(s) != 6 {
		return rgb{}, false
	}
	v, err := strconv.ParseUint(s, 16, 32)
	if err != nil {
		return rgb{}, false
	}
	return rgb{
		r: float64((v >> 16) & 0xff),
		g: float64((v >> 8) & 0xff),
		b: float64(v & 0xff),
	}, true
}

// channelLuminance applies the WCAG sRGB linearization to one 0..255 channel.
func channelLuminance(c float64) float64 {
	c = c / 255.0
	if c <= 0.03928 {
		return c / 12.92
	}
	return math.Pow((c+0.055)/1.055, 2.4)
}

// relativeLuminance returns the WCAG relative luminance of a color (0..1).
func relativeLuminance(c rgb) float64 {
	return 0.2126*channelLuminance(c.r) +
		0.7152*channelLuminance(c.g) +
		0.0722*channelLuminance(c.b)
}

// contrastRatio returns the WCAG contrast ratio between two colors (1..21).
func contrastRatio(a, b rgb) float64 {
	la := relativeLuminance(a)
	lb := relativeLuminance(b)
	lighter, darker := la, lb
	if darker > lighter {
		lighter, darker = darker, lighter
	}
	return (lighter + 0.05) / (darker + 0.05)
}

// parseTheme extracts "key value" color pairs from kitty .conf lines.
// Only keys whose value is a "#rrggbb" hex color are kept.
func parseTheme(lines []string) map[string]rgb {
	out := map[string]rgb{}
	for _, ln := range lines {
		ln = strings.TrimSpace(ln)
		if ln == "" || strings.HasPrefix(ln, "#") {
			// "#" alone starts a comment; color values use "#rrggbb" but
			// always appear after a key, so a leading "#" is a comment.
			continue
		}
		f := strings.Fields(ln)
		if len(f) < 2 {
			continue
		}
		if c, ok := parseHex(f[1]); ok {
			out[f[0]] = c
		}
	}
	return out
}

type report struct {
	name  string
	ratio float64
}

// rate gives a short WCAG verdict for a contrast ratio.
func rate(r float64) string {
	switch {
	case r >= 7.0:
		return "AAA"
	case r >= 4.5:
		return "AA"
	case r >= 3.0:
		return "AA large only"
	default:
		return "FAIL"
	}
}

// analyze computes contrast of every non-background color against background.
func analyze(theme map[string]rgb) ([]report, bool) {
	bg, ok := theme["background"]
	if !ok {
		return nil, false
	}
	var reps []report
	for name, c := range theme {
		if name == "background" {
			continue
		}
		reps = append(reps, report{name: name, ratio: contrastRatio(c, bg)})
	}
	sort.Slice(reps, func(i, j int) bool { return reps[i].ratio < reps[j].ratio })
	return reps, true
}

// --- Impure layer -----------------------------------------------------------

func readLines(path string) ([]string, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	var lines []string
	sc := bufio.NewScanner(f)
	for sc.Scan() {
		lines = append(lines, sc.Text())
	}
	return lines, sc.Err()
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: kitty-contrast <theme.conf>")
		os.Exit(2)
	}
	lines, err := readLines(os.Args[1])
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	theme := parseTheme(lines)
	reps, ok := analyze(theme)
	if !ok {
		fmt.Fprintln(os.Stderr, "error: no background color found")
		os.Exit(1)
	}
	fmt.Printf("%-24s %8s   %s\n", "color", "ratio", "WCAG")
	for _, r := range reps {
		fmt.Printf("%-24s %7.2f:1  %s\n", r.name, r.ratio, rate(r.ratio))
	}
}
