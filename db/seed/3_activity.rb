p "3. seeding activity"

admin = Admin.last

activities = [
  {
    name: "Stimulus Explosion",
    description: "Increase Stimulus of your child rapidly",
    frequency: Activity.frequencies[:weekly],
    category: Activity.categories[:stimulation],
    repetition: 2
  },
  {
    name: "Advanced Mobility",
    description: "Increase Mobility of your child",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:exercise],
    repetition: 10
  },
  {
    name: "Auditory Memory 2",
    description: "Increase Memory of your child",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:memory],
    repetition: 1
  },
  {
    name: "Auditory Magic",
    description: "Train and entertain with audio",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:play],
    repetition: 2
  },
  {
    name: "Knowledge Boosters",
    description: "Increase Knowledge of your child",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:knowledge],
    repetition: 2
  },
  {
    name: "Talk to listen",
    description: "Speak and stimulate",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:speaking],
    repetition: 1
  },
  {
    name: "Energy Ball",
    description: "Play with great energy",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:play],
    repetition: 10
  },
  {
    name: "Visual Solfege",
    description: "Train visual stimulus",
    frequency: Activity.frequencies[:daily],
    category: Activity.categories[:visual],
    repetition: 1
  },
  {
    name: "Finger Skills",
    description: "Train your child's neuro muscular connections",
    frequency: Activity.frequencies[:weekly],
    category: Activity.categories[:cognitive],
    repetition: 3
  },
  {
    name: "Foundation of logic",
    description: "Logical ability training",
    frequency: Activity.frequencies[:weekly],
    category: Activity.categories[:logical],
    repetition: 2
  },
]

admin_id = { admin_id: admin.id }

activities.each do |activity|
  Activity.create(activity.merge(admin_id))
end