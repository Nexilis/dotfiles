package main

import (
	"math"
	"testing"
)

func TestParseHex(t *testing.T) {
	tests := []struct {
		in      string
		want    rgb
		wantOK  bool
	}{
		{"#ffffff", rgb{255, 255, 255}, true},
		{"#000000", rgb{0, 0, 0}, true},
		{"  #4c4f69 ", rgb{76, 79, 105}, true},
		{"#fff", rgb{}, false},
		{"notacolor", rgb{}, false},
		{"#gggggg", rgb{}, false},
	}
	for _, tt := range tests {
		got, ok := parseHex(tt.in)
		if ok != tt.wantOK || (ok && got != tt.want) {
			t.Errorf("parseHex(%q) = %v,%v want %v,%v", tt.in, got, ok, tt.want, tt.wantOK)
		}
	}
}

func approx(a, b float64) bool { return math.Abs(a-b) < 0.01 }

func TestContrastRatio(t *testing.T) {
	white := rgb{255, 255, 255}
	black := rgb{0, 0, 0}
	if r := contrastRatio(white, black); !approx(r, 21.0) {
		t.Errorf("white/black = %.2f want 21.00", r)
	}
	if r := contrastRatio(white, white); !approx(r, 1.0) {
		t.Errorf("white/white = %.2f want 1.00", r)
	}
	// Symmetry: order must not matter.
	if contrastRatio(white, black) != contrastRatio(black, white) {
		t.Error("contrastRatio not symmetric")
	}
}

func TestRelativeLuminance(t *testing.T) {
	// Known WCAG anchors.
	if l := relativeLuminance(rgb{255, 255, 255}); !approx(l, 1.0) {
		t.Errorf("white luminance = %.4f want 1.0", l)
	}
	if l := relativeLuminance(rgb{0, 0, 0}); !approx(l, 0.0) {
		t.Errorf("black luminance = %.4f want 0.0", l)
	}
}

func TestRate(t *testing.T) {
	cases := map[float64]string{
		7.5: "AAA", 7.0: "AAA",
		5.0: "AA", 4.5: "AA",
		3.5: "AA large only", 3.0: "AA large only",
		2.0: "FAIL", 1.0: "FAIL",
	}
	for r, want := range cases {
		if got := rate(r); got != want {
			t.Errorf("rate(%.1f) = %q want %q", r, got, want)
		}
	}
}

func TestParseThemeSkipsComments(t *testing.T) {
	lines := []string{
		"# a comment",
		"foreground #4c4f69",
		"background  #eff1f5",
		"font_size 12.0", // not a color
		"",
	}
	theme := parseTheme(lines)
	if len(theme) != 2 {
		t.Fatalf("got %d colors, want 2: %v", len(theme), theme)
	}
	if theme["foreground"] != (rgb{76, 79, 105}) {
		t.Errorf("foreground = %v", theme["foreground"])
	}
}

func TestAnalyzeSortsAscending(t *testing.T) {
	theme := map[string]rgb{
		"background": {239, 241, 245},
		"high":       {0, 0, 0},
		"low":        {200, 200, 200},
	}
	reps, ok := analyze(theme)
	if !ok || len(reps) != 2 {
		t.Fatalf("analyze ok=%v len=%d", ok, len(reps))
	}
	if reps[0].name != "low" {
		t.Errorf("expected lowest-contrast first, got %s", reps[0].name)
	}
}
