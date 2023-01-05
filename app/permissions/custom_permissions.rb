# frozen_string_literal: true

class CustomPermissions < Decidim::DefaultPermissions
  def permissions
    return permission_action unless permission_action.scope == :public

    apply_searches_permissions(permission_action)
    apply_profiles_permissions(permission_action)

    permission_action
  end

  private

  def apply_searches_permissions(permission_action)
    return unless permission_action.subject == :searches

    case permission_action.action
    when :read
      toggle_allow(user.present?)
    end
  end

  def apply_profiles_permissions(permission_action)
    return unless permission_action.subject == :profiles

    case permission_action.action
    when :read
      toggle_allow(user.present?)
    end
  end
end
