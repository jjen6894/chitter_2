describe User do

  let!(:user) do
    User.create(email: "test@test.com", password: "secret1234")
  end

  it 'authenticates when given a valid email address and password' do
    authenticated_user = User.authenticate(user.email, "secret1234")
    # require'pry';binding.pry
    expect(authenticated_user).to eq user
  end
  it 'does not authenticate when given an incorrect password' do
  expect(User.authenticate(user.email, 'wrong_stupid_password')).to be_nil
end

end
