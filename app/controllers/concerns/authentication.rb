module Authentication
  extend ActiveSupport::Concern

  included do
    # before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    # def allow_unauthenticated_access(**options)
    #   skip_before_action :require_authentication, **options
    # end
  end

  private

  def require_authentication_for(resource_name)
    session = require_authentication
  
    if session.nil? || session[:resource_type] != resource_name.to_s.capitalize
      request_authentication("Unauthorized access")

      return
    end
  
    session
  end
  
  def require_admin_authentication
    require_authentication_for("admin")
  end
  
  def require_user_authentication
    require_authentication_for("user")
  end
  

    def authenticated?
      resume_session
    end

    def require_authentication
      session = resume_session
    end

    def resume_session
      Current.session ||= find_session_by_cookie
    end

    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    def request_authentication(error="Invalid Token")
      render json: {
        code: 401,
        error: error,
        status: "error"
      }, status: :unauthorized

      return
    end

    def start_new_session_for(resource)
      resource.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end 
    end

    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end
end
