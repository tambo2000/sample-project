module ApplicationHelper
  def get_name_or_email
    current_user.name.strip.empty? ? current_user.email : current_user.name
  end
end
