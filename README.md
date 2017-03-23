# bobvillarreal
Author Bob Villarreal's Middleman-generated site -- http://testing.bobvillarreal.com/clawing/

This project uses the Ikarus gallery management tool (https://github.com/rcieoktgieke/Ikarus -- see below the benefits of this gallery management), as well as some content-preprocessing concepts borrowed from it to generate pages for all online content belonging to author Bob Villarreal's books.



Follow directions in install_guide.txt to prepare environment.

To set website contents, change files in input_data folder.
To run contents preprocessing, do "cd input_scripts" and "ruby gallaudet.rb"

To run local server, run "middleman"
To run preprocessing and create a build folder of the website, run "sh build_villarreal.sh"



The following (copied from https://github.com/rcieoktgieke/Curtiss) addresses the benefits of using the Curtiss gallery management tool (on this project, used with the Ikarus wrapper):

Curtiss is a platform to generate static galleries by reading and scaling image files. This allows for optimal load times, because the thumbnails created by the image processing script are no larger than the dimensions they will be loaded with. By keeping the gallery static, images can be scaled and aligned nicely while maintaining a gallery as responsive as possible, because no computaion and re-rendering is passed on to the client. It also reduces server load; because each request is fulfilled with the same response, only minimal work is required on backend. A more detailed examination of the benefits of a static site can be found here: weber.lol.

What Curtiss does:

Curtiss reads images from a configurable directory, scales such that all images which share a row are the same height (but not all rows are the same height), and saves the scaled images to a configurable output directory. The front end then renders the images into a fully-contained gallery that can be placed anywhere on any webpage, with a width (and image margins) specified in configuration. A more detailed description of how it does all of this will likely appear here at some later time, but until then, documentation can be found throughout most of the code.
