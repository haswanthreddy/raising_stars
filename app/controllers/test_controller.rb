class TestController < ApplicationController
    before_action :require_user_authentication

    def index
        render json: {
            working: "message",
            user: Current.session.resource
        }
    end
end
