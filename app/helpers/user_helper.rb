# frozen_string_literal: true

module UserHelper
  def is_admin?
    user_signed_in? && current_user.admin?
  end

  def is_user?
    user_signed_in? && current_user.user?
  end
end
