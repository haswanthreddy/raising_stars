p "4. program activities"

program = Program.first

program_activities = [
  { program_id: program.id, activity_id: 1, frequency: "weekly", repetition: 3 },
  { program_id: program.id, activity_id: 2, frequency: "weekly", repetition: 2 },
  { program_id: program.id, activity_id: 3, frequency: "daily", repetition: 1 },
  { program_id: program.id, activity_id: 4, frequency: "daily", repetition: 2 },
  { program_id: program.id, activity_id: 5, frequency: "daily", repetition: 2 },
  { program_id: program.id, activity_id: 6, frequency: "daily", repetition: 2 },
  { program_id: program.id, activity_id: 7, frequency: "daily", repetition: 10 },
  { program_id: program.id, activity_id: 8, frequency: "weekly", repetition: 1 },
]

ProgramActivity.insert_all!(
  program_activities
)