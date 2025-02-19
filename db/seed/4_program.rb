p "4. seeding program"

user = User.last
admin = Admin.last


Program.create(
  user_id: user.id,
  admin_id: admin.id,
  title: "initial phase",
  start_date: Date.today - 1.day,
  end_date: Date.today + 2.month
)