package main

import (
	"./pqueue64"
	"fmt"
	"math"
	"os"
	"strings"
)

type Target struct {
	Base, Power int
}

func AddTargets(targetQueue *pqueue64.PQueue, seen map[Target]bool, base int, power int) {
	incBase := Target{Base: base + 1, Power: power}
	incPower := Target{Base: base, Power: power + 1}

	if !seen[incBase] {
		targetQueue.Push(incBase, int64(math.Pow(float64(base+1), float64(power))))
	}
	if !seen[incPower] {
		targetQueue.Push(incPower, int64(math.Pow(float64(base), float64(power+1))))
	}

	seen[incBase] = true
	seen[incPower] = true
}

func Search(base int, power int) ([]int, bool) {
	target := int64(math.Pow(float64(base), float64(power)))

	set := make([]int, power-1)
	for i, _ := range set {
		set[i] = 1
	}

	var sum int64

	for {
		sum = 0
		for _, v := range set {
			sum += int64(math.Pow(float64(v), float64(power)))
		}

		// We matched!
		if sum == target {
			return set, true
		}

		i := 0
		for i < len(set) {
			set[i] += 1
			if set[i] < base {
				break
			}
			i += 1
		}
		if i == len(set) {
			return nil, false
		}

		for i > 0 {
			set[i-1] = set[i]
			i -= 1
		}
	}

	return nil, false
}

func main() {
	var targetQueue *pqueue64.PQueue = pqueue64.NewPQueue(pqueue64.MINPQ)
	var seen map[Target]bool = make(map[Target]bool)

	initialTarget := Target{Base: 2, Power: 3}
	targetQueue.Push(initialTarget, int64(math.Pow(float64(initialTarget.Base), float64(initialTarget.Power))))
	seen[initialTarget] = true

	for {
		target, _ := targetQueue.Pop()
		base := target.(Target).Base
		power := target.(Target).Power

		fmt.Printf("Searching for %d^%d\t(%d)\n", base, power, int64(math.Pow(float64(base), float64(power))))

		set, found := Search(base, power)

		if found {
			addends := make([]string, len(set))
			for i, v := range set {
				addends[i] = fmt.Sprintf("%d^%d", v, power)
			}
			fmt.Printf(
				"Found! (%d) %d^%d = %s\n",
				int64(math.Pow(float64(base), float64(power))),
				base,
				power,
				strings.Join(addends, " + "))
			os.Exit(0)
		}

		AddTargets(targetQueue, seen, base, power)
	}

}
