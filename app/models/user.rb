class User
  include Mongoid::Document
  include Passwordable

  field :first_name, type: String
  field :last_name, type: String
  field :username, type: String
  field :email, type: String
  field :password, type: String

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :username
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  before_validation :sanitize_data


  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def sanitize_data
    # We want lowercase emails to make it easy to look up via authentication!
    self.email = email.downcase.strip if email
  end
end

