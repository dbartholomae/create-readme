LicenseParser = require '../components/license.coffee'
mockFs = require 'mock-fs'

describe "A LicenseParser", ->
  pkg = null
  beforeEach ->
    pkg = require '../../package.json'
    pkg.license = "MIT"
    pkg.git =
      user: "dbartholomae"
      repo: "readme-creator"
      branch: "master"

  afterEach ->
    mockFs.restore()

  it "returns a full license object if the license file is found", ->
    mockFs
      'LICENSE': "All your codebase are belong to us!!!11"

    licenseParser = new LicenseParser()
    expect(licenseParser.run pkg).to.eventually.deep.equal
      name: 'MIT'
      file: 'LICENSE'

  it "returns a license object without file if no license file is found", ->
    mockFs()

    licenseParser = new LicenseParser()
    expect(licenseParser.run pkg).to.eventually.deep.equal
      name: 'MIT'
      file: ''

  it "returns null if license is not set", ->
    pkg.license = null
    mockFs()

    licenseParser = new LicenseParser()
    expect(licenseParser.run pkg).to.eventually.equal null

  it "can be configured via options", ->
    mockFs
      'LICENSE.md': "All your codebase are belong to us!!!11"

    licenseParser = new LicenseParser
      licenseFile: 'LICENSE.md'
    expect(licenseParser.run pkg).to.eventually.deep.equal
      name: 'MIT'
      file: 'LICENSE.md'
