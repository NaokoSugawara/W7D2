class User < ApplicationRecord

    validates :email, :password_digest, :session_token, presence: true

    attr_reader :password

    before_validation :ensure_session_token

    def find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def generate_unique_session_token
        loop do
            session_token = SecureRandom::urlsafe_base64
            session_token unless User.exists?(session_token: session_token)
        end
    end
    
    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def password=(password)
        self.password_digest = BCrypt::password.create(password)
        @password = password
    end
    
    def is_password?(password)
        password_object = BCrypt::password.new(password)
        password_object.is_password?(password)
    end

end
