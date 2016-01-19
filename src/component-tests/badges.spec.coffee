BadgeParser = require '../components/badges.coffee'

describe "A BadgeParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  it "should return an empty list if git is not set in pkg", ->
    pkg.git = null
    badgeParser = new BadgeParser()
    expect(badgeParser.run pkg).to.eventually.deep.equal []

  it "should create the badges it is asked for", ->
    badgeParser = new BadgeParser(
      badges: ['travis']
    )
    expect(badgeParser.run pkg).to.eventually.deep.equal [{
      name: "build status"
      "img": "https://travis-ci.org/dbartholomae/readme-creator.svg"
      "url": "https://travis-ci.org/dbartholomae/readme-creator"
    }]
