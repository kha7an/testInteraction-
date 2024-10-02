# spec/interactions/users/create_spec.rb
require 'rails_helper'

RSpec.describe Users::Create, type: :interaction do
  let(:valid_inputs) do
    {
      name: 'Аяз',
      patronymic: 'Хас',
      surname: 'Хасанов',
      email: 'test@test.com',
      age: 20,
      nationality: 'Татарин',
      country: 'Россия',
      gender: 'male',
      interests: ['coding', 'hockey'],
      skills: 'Ruby, Rails'
    }
  end

  it 'создание валид пользователя ' do
    result = Users::Create.run(valid_inputs)
    expect(result.valid?).to be true
    user = result.result
    expect(User.count).to eq(1)
    expect(user.full_name).to eq('Хасанов Аяз Хас')
    expect(user.interests.pluck(:name)).to match_array(['coding', 'hockey'])
    expect(user.skills.pluck(:name)).to match_array(['Ruby', 'Rails'])
  end

  it 'создание пользователя с уже существующим email' do
    User.create!(valid_inputs.except(:interests, :skills))
    result = Users::Create.run(valid_inputs)
    expect(result.valid?).to be false
    expect(result.errors.full_messages).to include('Email is invalid')
  end

  it 'создание пользователя с невалид возрастом' do
    result = Users::Create.run(valid_inputs.merge(age: -1))
    expect(result.valid?).to be false
    expect(result.errors.full_messages).to include('Age must be greater than 0')
  end

  it 'создание пользователя с не валид полом' do
    result = Users::Create.run(valid_inputs.merge(gender: 'other'))
    expect(result.valid?).to be false
    expect(result.errors.full_messages).to include('Gender is not included in the list')
  end
end
