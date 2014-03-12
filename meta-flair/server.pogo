gm = require 'gm'
im = gm.sub class (image magick: true)
request = require 'request'
http = require 'http'
fs = require 'fs'
tmp = require 'tmp'

urls = [
    "https://travis-ci.org/artemave/37-pieces-of-flair.png"
    "https://badge.fury.io/rb/37-pieces-of-flair.png"
    "https://badge.fury.io/gh/artemave%2F37-pieces-of-flair.png"
    "https://badge.fury.io/js/37-pieces-of-flair.png"
    "https://gemnasium.com/artemave/37-pieces-of-flair.png"
    "http://stillmaintained.com/artemave/37-pieces-of-flair.png"
    "https://codeclimate.com/github/artemave/37-pieces-of-flair.png"
    "https://d2weczhvl823v0.cloudfront.net/artemave/37-pieces-of-flair/trend.png"
    "https://app.wercker.com/status/dbb3610426d65fd5699570ca58f942ce/s/master"
]

respond (req, response) =
    make a big badge @(err, stdout)
        if (err)
            response.end (err)
        else
            response.set header 'Content-Type' 'image/png'
            stdout.pipe (response)

http.create server (respond).listen (process.env.PORT || 3737)

make a big badge! () =
    paths = download all badges!
    append badges at (paths).stream! 'png'

download all badges! = [url <- urls, download badge! (url) ]

download badge! (url) =
    path = tmp.file!
    download (url) to (path) !

download (url) to (path) (callback) =
    stream = fs.create write stream (path)
    stream.on 'close' @{ callback (null, path) }
    stream.on 'error' @(e) @{ callback (e) }
    request.get (url).pipe (stream)

append badges at (paths) =
    img = im (paths.0)
    for (i = 1, i < paths.length, ++i)
        img := img.append (paths.(i))

    img
