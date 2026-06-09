package main

import "testing"

func TestTopColors(t *testing.T) {
	tests := []struct {
		name   string
		pixels []string
		n      int
		want   []tally
	}{
		{
			name:   "orders by frequency, most common first",
			pixels: []string{"#aaa", "#bbb", "#aaa", "#ccc", "#aaa", "#bbb"},
			n:      3,
			want:   []tally{{"#aaa", 3}, {"#bbb", 2}, {"#ccc", 1}},
		},
		{
			name:   "truncates to n",
			pixels: []string{"#aaa", "#aaa", "#bbb", "#ccc"},
			n:      1,
			want:   []tally{{"#aaa", 2}},
		},
		{
			name:   "n larger than distinct colors returns all",
			pixels: []string{"#aaa", "#bbb"},
			n:      10,
			want:   []tally{{"#aaa", 1}, {"#bbb", 1}},
		},
		{
			name:   "empty input returns empty",
			pixels: []string{},
			n:      5,
			want:   []tally{},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := topColors(tt.pixels, tt.n)
			if len(got) != len(tt.want) {
				t.Fatalf("len(got)=%d want %d (%v)", len(got), len(tt.want), got)
			}
			for i := range got {
				if got[i] != tt.want[i] {
					t.Errorf("got[%d]=%+v want %+v", i, got[i], tt.want[i])
				}
			}
		})
	}
}
