require "rmagick" #rmagick is the library used to access and edit image files. It defines Magick::ImageList used below.

# curtiss_init iterates through the files in gallery_folder, images_per_row at a time. For each set of images_per_row images, it finds the minimum height of the images, and adds up the width of each image if it were scaled to the minimum height. If this width is less than total_width - width_adjustment - image_margins * (the number of images in the row - 1), it then adds another image to the list. It repeats this until the total reaches total_width - width_adjustment, at which point it scales each image by a factor of (total_width - width_adjustment - image_margins * (the number of images in the row - 1)) / the added width of the images (as if scaled to minimum height), saves the result, and pushes the filenames to a row of the gallery matrix. When it reaches the point where less than images_per_row filenames are left, it scales the remaining images, if any, such that they are the same height as each other and fill the same width as the other rows. 
def curtiss_init(gallery, filenames, gallery_folder, thumbs_folder, total_width, images_per_row, image_margins, width_adjustment)
  #filenames = Dir.entries("../../images/" + gallery_folder).select {|filename| filename != "." and filename != ".." and filename != thumbs_folder } 
  index = 0
  while index + images_per_row <= filenames.length do
    minHeight = nil
    for i in index..index + images_per_row - 1
      filename = filenames[i]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentHeight = currentImage.first.rows
      minHeight = currentHeight if (minHeight == nil or currentHeight < minHeight)
    end

    width = 0.0
    for i in index..index + images_per_row - 1
      filename = filenames[i]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentWidth = currentImage.first.columns
      currentHeight = currentImage.first.rows
      width += currentWidth * minHeight/currentHeight
    end

    imagesToAdd = 0
    while width < total_width
      imagesToAdd += 1
      filename = filenames[index + images_per_row + imagesToAdd]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentWidth = currentImage.first.columns
      currentHeight = currentImage.first.rows
      width += currentWidth * minHeight/currentHeight
    end

    widthRatio = (total_width - width_adjustment - (images_per_row + imagesToAdd - 1) * image_margins)/width

    row = []
    for i in index..index + images_per_row + imagesToAdd - 1
      filename = filenames[i]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentHeight = currentImage.first.rows
      scaleRatio = widthRatio * minHeight/currentHeight
      thumbnail = currentImage.scale(scaleRatio)
      thumbnail.write("/home/maroon/mrv/source/images/" + gallery_folder + "/" + thumbs_folder + "/" + filename)
      row.push(filename)
    end
    gallery.push(row)

    index = index + images_per_row + imagesToAdd
  end

  if index < filenames.length
    for i in index..filenames.length - 1
      filename = filenames[i]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentHeight = currentImage.first.rows
      minHeight = currentHeight if (minHeight == nil or currentHeight < minHeight)
    end

    width = 0.0
    for i in index..filenames.length - 1
      filename = filenames[i]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentWidth = currentImage.first.columns
      currentHeight = currentImage.first.rows
      width += currentWidth * minHeight/currentHeight
    end

    widthRatio = (total_width - width_adjustment - (filenames.length - index - 1) * image_margins)/width

    row = []
    for i in index..filenames.length - 1
      filename = filenames[i]
      currentImage = Magick::ImageList.new("/home/maroon/mrv/source/images/" + gallery_folder + "/" + filename)
      currentHeight = currentImage.first.rows
      scaleRatio = widthRatio * minHeight/currentHeight
      thumbnail = currentImage.scale(scaleRatio)
      thumbnail.write("/home/maroon/mrv/source/images/" + gallery_folder + "/" + thumbs_folder + "/" + filename)
      row.push(filename)
    end
    gallery.push(row)
  end

  gallery.each do |row|
    row.each do |filename|
      puts "Curtiss: #{filename}"
    end
  end
end