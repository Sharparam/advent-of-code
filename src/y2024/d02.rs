use aoc_macros::aoc;

#[aoc(2024, 2, 1)]
pub fn part1(input: &str) -> String {
    // Example solution for 2024 Day 2 Part 1
    let reports: Vec<Vec<i32>> = input
        .trim()
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|n| n.parse().unwrap())
                .collect()
        })
        .collect();

    let safe_count = reports
        .iter()
        .filter(|report| is_safe_report(report))
        .count();

    safe_count.to_string()
}

#[aoc(2024, 2, 2)]
pub fn part2(input: &str) -> String {
    // Example solution for 2024 Day 2 Part 2
    let reports: Vec<Vec<i32>> = input
        .trim()
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|n| n.parse().unwrap())
                .collect()
        })
        .collect();

    let safe_count = reports
        .iter()
        .filter(|report| is_safe_with_dampener(report))
        .count();

    safe_count.to_string()
}

fn is_safe_report(report: &[i32]) -> bool {
    if report.len() < 2 {
        return true;
    }

    let increasing = report[1] > report[0];

    for window in report.windows(2) {
        let diff = window[1] - window[0];
        let abs_diff = diff.abs();

        if !(1..=3).contains(&abs_diff) {
            return false;
        }

        if increasing && diff <= 0 {
            return false;
        }

        if !increasing && diff >= 0 {
            return false;
        }
    }

    true
}

fn is_safe_with_dampener(report: &[i32]) -> bool {
    if is_safe_report(report) {
        return true;
    }

    // Try removing each level
    for i in 0..report.len() {
        let mut modified = report.to_vec();
        modified.remove(i);
        if is_safe_report(&modified) {
            return true;
        }
    }

    false
}
