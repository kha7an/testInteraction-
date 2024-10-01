class Users::Create < ActiveInteraction::Base
  string :name
  string :patronymic
  string :surname
  string :email
  integer :age
  string :nationality
  string :country
  string :gender
  array :interests, default: []
  string :skills

  validates :name, :patronymic, :surname, :email, :nationality, :country, :gender, presence: true
  validates :age, numericality: { greater_than: 0, less_than_or_equal_to: 90 }
  validates :gender, inclusion: { in: %w[male female] }

  validate :email_uniqueness

  def execute
    user = User.new(user_attributes)

    if user.save
      associate_interests(user)
      associate_skills(user)
      user
    else
      errors.merge!(user.errors)
      nil
    end
  end

  private

  def email_uniqueness
    errors.add(:email, 'занято') if User.exists?(email: email)
  end

  def user_attributes
    inputs.except(:interests, :skills).merge(full_name: full_name)
  end

  def full_name
    "#{surname} #{name} #{patronymic}"
  end

  def associate_interests(user)
    interests.each do |interest_name|
      interest = Interest.find_or_create_by(name: interest_name)
      user.interests << interest unless user.interests.include?(interest)
    end
  end

  def associate_skills(user)
    skill_names = skills.split(',').map(&:strip)
    skill_names.each do |skill_name|
      skill = Skill.find_or_create_by(name: skill_name)
      user.skills << skill unless user.skills.include?(skill)
    end
  end
end
