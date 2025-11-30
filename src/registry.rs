use once_cell::sync::Lazy;
use std::collections::HashMap;

/// Function type for AoC solutions
pub type SolutionFn = fn(&str) -> String;

/// Metadata for a solution
#[derive(Debug, Clone)]
pub struct Solution {
    pub year: u32,
    pub day: u32,
    pub part: u32,
    pub name: &'static str,
    pub function: SolutionFn,
}

/// Global registry for all AoC solutions
pub struct Registry {
    solutions: std::sync::Mutex<HashMap<(u32, u32, u32), Solution>>,
}

impl Registry {
    fn new() -> Self {
        Self {
            solutions: std::sync::Mutex::new(HashMap::new()),
        }
    }

    /// Register a solution with the registry
    pub fn register_solution(
        &self,
        year: u32,
        day: u32,
        part: u32,
        name: &'static str,
        function: SolutionFn,
    ) {
        let solution = Solution {
            year,
            day,
            part,
            name,
            function,
        };

        let mut solutions = self.solutions.lock().unwrap();
        solutions.insert((year, day, part), solution);
    }

    /// Get a specific solution
    pub fn get_solution(&self, year: u32, day: u32, part: u32) -> Option<Solution> {
        let solutions = self.solutions.lock().unwrap();
        solutions.get(&(year, day, part)).cloned()
    }

    /// Get all solutions for a specific year and day
    pub fn get_day_solutions(&self, year: u32, day: u32) -> Vec<Solution> {
        let solutions = self.solutions.lock().unwrap();
        solutions
            .values()
            .filter(|s| s.year == year && s.day == day)
            .cloned()
            .collect()
    }

    /// Get all solutions for a specific year
    pub fn get_year_solutions(&self, year: u32) -> Vec<Solution> {
        let solutions = self.solutions.lock().unwrap();
        solutions
            .values()
            .filter(|s| s.year == year)
            .cloned()
            .collect()
    }

    /// Get all available solutions
    pub fn get_all_solutions(&self) -> Vec<Solution> {
        let solutions = self.solutions.lock().unwrap();
        solutions.values().cloned().collect()
    }

    /// Get all available years
    pub fn get_years(&self) -> Vec<u32> {
        let solutions = self.solutions.lock().unwrap();
        let mut years: Vec<u32> = solutions.values().map(|s| s.year).collect();
        years.sort_unstable();
        years.dedup();
        years
    }

    /// Get all available days for a year
    pub fn get_days(&self, year: u32) -> Vec<u32> {
        let solutions = self.solutions.lock().unwrap();
        let mut days: Vec<u32> = solutions
            .values()
            .filter(|s| s.year == year)
            .map(|s| s.day)
            .collect();
        days.sort_unstable();
        days.dedup();
        days
    }
}

/// Global registry instance
pub static REGISTRY: Lazy<Registry> = Lazy::new(Registry::new);
