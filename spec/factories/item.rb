FactoryBot.define do
  factory :item do
    name { 'Gol Turbo' }
    description do
      'VW GOL GTS PLACA KCG0165 SEBASTIANOPOLIS DO SUL - ANO 87/87 ' \
        'COR CINZA - COMB ALCOOL -CHASSI 9BWZZZ30ZHT066498 ' \
        'MOTOR UE182622 - RENAVAN 112936709 ' \
        'SUCATA SEM DIREITO A DOCUMENTO ' \
        'MELHOR CARRO JÁ FEITO NO BRASIL.'
    end
    photo { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/images/gol-gts.jpg'), 'image/jpeg') }
    weight { 50_000 }
    width { 500 }
    height { 180 }
    depth { 400 }
    user { nil }

    trait :with_user do
      user
    end
  end
end
