require "digest/sha1"

module Passwordable
  extend ActiveSupport::Concern

  included do
    attr_accessor :password

    field :password_salt,      :type => String
    field :encrypted_password, :type => String
    field :password_reset_key, :type => String

    validates_presence_of :password, :on => :create

    before_save :encrypt_password
  end

  class PasswordHelper
    def self.pepper
      "b43c89c296285a8c7368eebbe57866a0ebfbb4408fc40a7d9003c4971941202dc158224924925c6057903a43ce95e46b8e3c95caa95444bcdff661c1778b1748"
    end

    def self.digest(password, stretches, salt, pepper)
      digest = pepper
      stretches.times {digest = secure_digest(salt, digest, password, pepper)}
      digest
    end

    private

    def self.secure_digest(*tokens)
      ::Digest::SHA1.hexdigest('--' << tokens.flatten.join( '--' ) << '--')
    end
  end

  module ClassMethods
    def generate_secret_key
      SecureRandom.base64(24).tr('+/=', '').strip.delete("\n")
    end
  end

  def valid_password?(incoming_password)
    password_digest(incoming_password) == encrypted_password
  end

  def reset_password!(password)
    self.password = password

    self.password_reset_key = nil

    errors.add(:password, I18n.t('errors.accounts.password.blank')) if password.blank?

    errors.empty? && save
  end

  private

  def password_digest(password)
    PasswordHelper.digest(password, 10, password_salt, PasswordHelper.pepper)
  end

  def encrypt_password
    if password.present?
      self.password_salt = SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
      self.encrypted_password = password_digest(password)
    end
  end
end
