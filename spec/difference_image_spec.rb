require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require 'compaa'

describe Compaa::DifferenceImage do
  it "creates a reference image" do
		difference_image_path =
			File.join %w[artifacts differences_in_screenshots_this_run dir file.png_difference.gif]

		subject = Compaa::DifferenceImage.new difference_image_path

		file_manager = MiniTest::Mock.new
		subject.file_manager = file_manager

		file_manager.expect :mkdir_p, true, [File.join(%w{artifacts reference_screenshots dir})]

		file_manager.expect :cp, true,
			[ File.join(%w[artifacts screenshots_generated_this_run dir file.png]),
				File.join(%w[artifacts reference_screenshots          dir file.png]) ]

		file_manager.expect :rm, true, [difference_image_path]

		subject.create_reference_image

		file_manager.verify
	end

	it "provides its corresponding reference image path" do
		path =
			File.join %w[artifacts differences_in_screenshots_this_run dir file.png_difference.gif]

		reference_path =
			File.join %w[artifacts reference_screenshots dir file.png]

		Compaa::DifferenceImage.new(path).reference_path.must_equal reference_path
	end
end
