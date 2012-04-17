require 'spec_helper'

describe MinecraftPlayer do

  it { should belong_to(:user) }


# ---
# Identity


  it { should have_field(:username) }
  # it { should validate_exclusion_of(:username).in(subject.class.blacklist) }
  it { should validate_length_of(:username).within(1..16) }
  it { should validate_format_of(:username).with_format(/^\w+$/) }
  it { should validate_uniqueness_of(:username) }

  it { should have_field(:slug) }

  it "sets the slug when setting the username" do
    subject.username = 'Foobar_baz'
    subject.slug.should == 'foobar_baz'
  end


# ---
# Avatar


  it { should respond_to(:avatar) }

  it "fetches avatars from Mojang" do
    subject.should_receive(:remote_avatar_url=).with(kind_of(String))
    subject.fetch_avatar
  end


# ---
# Stats


  it { should have_field(:minutes_played).of_type(Integer).with_default_value_of(0) }

  it { should have_field(:last_connected_at).of_type(DateTime) }


  # ---
  # Referrals

  describe '#verify!' do
    let(:new_user) { Fabricate :user, minecraft_player: nil }
    let(:new_player) { Fabricate :minecraft_player }
    let(:referring_user) { Fabricate :user }

    context 'referred by user' do
      before { new_user.referrer = referring_user }

      it 'credits both sides' do
        new_user.private_channel.should_receive(:trigger!).with('verified', new_player.to_json)
        new_player.verify!(new_user)

        new_user.credits.should == User::FREE_CREDITS + MinecraftPlayer::REFERRER_CREDITS
        referring_user.credits.should == User::FREE_CREDITS + MinecraftPlayer::REFEREE_CREDITS
      end
    end
  end



end
