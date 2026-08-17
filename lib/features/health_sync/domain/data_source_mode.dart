/// Where a given health metric is read from: Health Connect (synced from
/// Lyfta/MyFitnessPal/a scale app) or entries typed directly into Momentum.
/// Independent per metric — e.g. weight can be manual while workouts stay on
/// Health Connect.
enum DataSourceMode { healthConnect, manual }
