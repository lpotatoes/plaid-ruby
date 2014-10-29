require 'spec_helper.rb'
describe Plaid, 'Call' do
  before(:all) do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.customer_id = keys['CUSTOMER_ID']
      p.secret = keys['SECRET']
    end
  end

  it 'returns a response code of 200' do
    response = Plaid.call.add_account_auth('wells','plaid_test','plaid_good','test@plaid.com')
    expect(response[:code]).to eq(200)
  end

  it 'calls get_place and returns a response code of 200' do
    place = Plaid.call.get_place('526842af335228673f0000b7')
    expect(place[:code]).to eq(200)
  end

  it 'calls get_institutions and returns an array of institutions with id, name and type etc' do
    institutions = Plaid.call.get_institutions
    expect(institutions).to all( include("id", "name", "type") )
  end

  it 'returns a response code of 201' do
    Plaid.call.add_account_auth('chase','plaid_test','plaid_good','test@plaid.com')
  end

end

describe Plaid, 'Customer' do
  before :all do |_|
    keys = YAML::load(IO.read('./keys.yml'))
    Plaid.config do |p|
      p.customer_id = keys['CUSTOMER_ID']
      p.secret = keys['SECRET']
    end
  end

  it 'calls get_transactions and returns a response code of 200' do
    transactions = Plaid.customer.get_transactions('test')
    expect(transactions[:code]).to eq(200)
  end

  it 'calls mfa_step and returns a response code of 200' do
    new_account = Plaid.customer.mfa_auth_step('test','again','chase')
    expect(new_account[:code]).to eq(200)
  end

  it 'calls delete_account and returns a response code of 200' do
    message = Plaid.customer.delete_account('test')
    expect(message[:code]).to eq(200)
  end
end
