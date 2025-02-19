p "4. seeding program"

user = User.last
admin = Admin.last


Program.create(
  user_id: user.id,
  admin_id: admin.id,
  title: "initial phase",
  start_date: Date.today - 10.days,
  end_date: Date.today + 80.days
)