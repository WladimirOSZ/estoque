FactoryBot.define do
  factory :user do
    password { 'password' }
    cpf { '621.830.060-99' }
    name { 'Wladimir Souza' }
    email { 'user@gmail.com' }

    trait :second_user do
      email { 'user2@gmail.com' }
      cpf { '728.773.530-01' }
    end

    trait :admin do
      email { 'admin@punti.com' }
      cpf { '065.625.380-09' }
      role { :admin }
    end

    trait :second_admin do
      email { 'admin2@punti.com' }
      cpf { '259.857.290-44' }
      role { :admin }
    end
  end
end
