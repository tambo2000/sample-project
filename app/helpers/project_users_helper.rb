module ProjectUsersHelper
  def possible_viewers(project)
    possible_viewers_array = User.all.map { |user| [user.email, user.id] }
    possible_viewers_array.delete_if { |user| (user[0] == current_user.email || project.viewers.include?(User.find(user[1]))) }
    possible_viewers_array
  end
end
