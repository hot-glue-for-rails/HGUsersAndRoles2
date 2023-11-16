class AddRoles < ActiveRecord::Migration[7.0]
  def change
    Role.create(name: "admin", label: "Admin")
    Role.create(name: "user", label: "User")
    Role.create(name: "superadmin", label: "Superadmin")
  end
end
