// colorpick reports the most common colors inside a rectangular region of a
// PNG. It exists to ground-truth which palette color an app is painting in a
// screenshot, so kitty theme fixes target the real failing hex value instead
// of a guess.
//
// usage: colorpick <image.png> <x> <y> <w> <h> [topN]
//   x,y,w,h are pixel coordinates of the region (top-left origin).
package main

import (
	"fmt"
	"image"
	_ "image/png"
	"os"
	"sort"
	"strconv"
)

// --- Pure layer -------------------------------------------------------------

type tally struct {
	hex   string
	count int
}

// topColors counts every pixel hex in pixels and returns the n most common,
// most-frequent first.
func topColors(pixels []string, n int) []tally {
	counts := map[string]int{}
	for _, p := range pixels {
		counts[p]++
	}
	out := make([]tally, 0, len(counts))
	for hex, c := range counts {
		out = append(out, tally{hex: hex, count: c})
	}
	// Count descending; ties broken by hex ascending for deterministic output.
	sort.Slice(out, func(i, j int) bool {
		if out[i].count != out[j].count {
			return out[i].count > out[j].count
		}
		return out[i].hex < out[j].hex
	})
	if n < len(out) {
		out = out[:n]
	}
	return out
}

// --- Impure layer -----------------------------------------------------------

func regionPixels(img image.Image, x, y, w, h int) []string {
	var out []string
	b := img.Bounds()
	for py := y; py < y+h && py < b.Max.Y; py++ {
		for px := x; px < x+w && px < b.Max.X; px++ {
			r, g, bl, _ := img.At(px, py).RGBA()
			out = append(out, fmt.Sprintf("#%02x%02x%02x", r>>8, g>>8, bl>>8))
		}
	}
	return out
}

func atoi(s string) int { v, _ := strconv.Atoi(s); return v }

func main() {
	if len(os.Args) < 6 {
		fmt.Fprintln(os.Stderr, "usage: colorpick <image.png> <x> <y> <w> <h> [topN]")
		os.Exit(2)
	}
	f, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Fprintln(os.Stderr, "error:", err)
		os.Exit(1)
	}
	defer f.Close()
	img, _, err := image.Decode(f)
	if err != nil {
		fmt.Fprintln(os.Stderr, "decode error:", err)
		os.Exit(1)
	}
	x, y, w, h := atoi(os.Args[2]), atoi(os.Args[3]), atoi(os.Args[4]), atoi(os.Args[5])
	n := 8
	if len(os.Args) > 6 {
		n = atoi(os.Args[6])
	}
	pixels := regionPixels(img, x, y, w, h)
	total := len(pixels)
	if total == 0 {
		fmt.Fprintln(os.Stderr, "error: empty region")
		os.Exit(1)
	}
	fmt.Printf("region %d,%d %dx%d  (%d px)\n", x, y, w, h, total)
	for _, t := range topColors(pixels, n) {
		fmt.Printf("  %s  %5.1f%%  (%d)\n", t.hex, 100*float64(t.count)/float64(total), t.count)
	}
}
