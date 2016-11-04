require "rmagick" #rmagick is the library used to access and edit image files. It defines Magick::ImageList used below.
CURTISS_VERBOSE = false

# curtiss_init iterates through the files in gallery_folder, images_per_row at a time. For each set of images_per_row images, it finds the minimum height of the images, and adds up the width of each image if it were scaled to the minimum height. If this width is less than total_width - width_adjustment - image_margins * (the number of images in the row - 1), it then adds another image to the list. It repeats this until the total reaches total_width - width_adjustment, at which point it scales each image by a factor of (total_width - width_adjustment - image_margins * (the number of images in the row - 1)) / the added width of the images (as if scaled to minimum height), saves the result, and pushes the filenames to a row of the gallery matrix. When it reaches the point where less than images_per_row filenames are left, it scales the remaining images, if any, such that they are the same height as each other and fill the same width as the other rows.
def curtiss_init(gallery, images_info, gallery_folder, thumbs_folder, total_width, images_per_row, image_margins, width_adjustment)

  #images_info = Dir.entries("../../images/" + gallery_folder).select {|filename| filename != "." and filename != ".." and filename != thumbs_folder }
  index = 0
  while index + images_per_row <= images_info.length do
    minHeight = nil
    for i in index..index + images_per_row - 1
      image = images_info[i]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentHeight = currentImage.first.rows
      minHeight = currentHeight if (minHeight == nil or currentHeight < minHeight)
    end

    width = 0.0
    for i in index..index + images_per_row - 1
      image = images_info[i]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentWidth = currentImage.first.columns
      currentHeight = currentImage.first.rows
      width += currentWidth * minHeight/currentHeight
    end

    imagesToAdd = 0
    while width < total_width
      imagesToAdd += 1
      image = images_info[index + images_per_row + imagesToAdd]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentWidth = currentImage.first.columns
      currentHeight = currentImage.first.rows
      width += currentWidth * minHeight/currentHeight
    end

    widthRatio = (total_width - width_adjustment - (images_per_row + imagesToAdd - 1) * image_margins)/width

    row = []
    for i in index..index + images_per_row + imagesToAdd - 1
      image = images_info[i]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentHeight = currentImage.first.rows
      scaleRatio = widthRatio * minHeight/currentHeight
      thumbnail = currentImage.scale(scaleRatio)
      thumbnail.write(gallery_folder + "/" + thumbs_folder + "/" + image["filename"])
      row.push(image)
    end
    gallery.push(row)

    index = index + images_per_row + imagesToAdd
  end

  if index < images_info.length
    for i in index..images_info.length - 1
      image = images_info[i]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentHeight = currentImage.first.rows
      minHeight = currentHeight if (minHeight == nil or currentHeight < minHeight)
    end

    width = 0.0
    for i in index..images_info.length - 1
      image = images_info[i]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentWidth = currentImage.first.columns
      currentHeight = currentImage.first.rows
      width += currentWidth * minHeight/currentHeight
    end

    widthRatio = (total_width - width_adjustment - (images_info.length - index - 1) * image_margins)/width

    row = []
    for i in index..images_info.length - 1
      image = images_info[i]
      currentImage = Magick::ImageList.new(gallery_folder + "/" + image["filename"])
      currentHeight = currentImage.first.rows
      scaleRatio = widthRatio * minHeight/currentHeight
      thumbnail = currentImage.scale(scaleRatio)
      thumbnail.write(gallery_folder + "/" + thumbs_folder + "/" + image["filename"])
      row.push(image)
    end
    gallery.push(row)
  end

  if CURTISS_VERBOSE
    gallery.each do |row|
      row.each do |image|
        puts "CURTISS: #{image}"
      end
    end
  end
end
