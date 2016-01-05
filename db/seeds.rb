
# The first user is Super Admin
zigvuAdmin = User.create(first_name: "Zigvu", last_name: "Admin", email: "zigvu_admin@zigvu.com", password: "abcdefgh", password_confirmation: 'abcdefgh', zrole: "superAdmin")

# Create some stream
videoStream = Video::Stream.create(ztype: "webBroadcast", zstate: "stopped", zpriority: "none", name: "FunTube", base_url: "funtube.com")
