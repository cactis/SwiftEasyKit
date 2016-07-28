//
//  K.swift


import Foundation

struct K {

  struct Api {
    static var host = ""
    static var prefix = "api/"
    static var pushserver = ""
    static var pushserverSubscribe = ""
  }

  struct Text {
    static var finished = "✓"
  }

  struct Message {
    static var colors = [UIColor.fromRGB(73, green: 173, blue: 199), UIColor.fromRGB(158, green: 0, blue: 52), UIColor.fromRGB(153, green: 130, blue: 0)]
  }

  struct Font {
    static var number = "HelveticaNeue-UltraLight"
    static var ultraLight = "HelveticaNeue-UltraLight"
    static var icon = ""
  }


  struct Badge {
    static var color = UIColor.whiteColor()
    static var backgroundColor = UIColor.redColor()
    static var size: CGFloat = 12
  }

  struct Color {
    static var tabBar = UIColor.grayColor()
    static var tabBarBackgroundColor = UIColor.whiteColor()

    static var navigator = UIColor.fromRGB(255, green: 255, blue: 255)
    static var heart = UIColor.fromRGB(186, green: 50, blue: 133)
    static var rating = UIColor.fromRGB(241, green: 209, blue: 0)
    static var ratings = [UIColor.fromRGB(43, green: 97, blue: 172), UIColor.fromRGB(182, green: 56, blue: 130), UIColor.fromRGB(242, green: 208, blue: 0)]
    static var body = UIColor.fromRGB(232, green: 232, blue: 232)
    static var table = UIColor.fromRGB(232, green: 232, blue: 232)
    static var buttonBg = UIColor.fromRGB(38, green: 92, blue: 170)
    static var button = UIColor.fromRGB(240, green: 240, blue: 240)
    static var barButtonItem = K.BarButtonItem.color
    static var indicator = UIColor.fromRGB(226, green: 53, blue: 0)
    static var cartBg = UIColor.fromRGB(116, green: 166, blue: 221)
    static var border = K.Color.body.darker().darker()
    static var dark = UIColor.blackColor()
    static var light = UIColor.grayColor().darker()
    static var popup = UIColor.whiteColor()
    static var checked = K.Color.buttonBg
    static var unchecked = UIColor.lightGrayColor()
    static var text = UIColor.darkGrayColor()//.darker()
    static var facebook = UIColor.fromHex("3B5998")
    static var google = UIColor.fromRGB(203, green: 52, blue: 37)
    static var tip = UIColor.fromRGB(166, green: 0, blue: 21)
    static var cell = UIColor.fromRGB(255, green: 255, blue: 255)
    static var important = UIColor.fromRGB(186, green: 63, blue: 45)
    static var nonImportant = UIColor.lightGrayColor()
    static var image = UIColor.whiteColor()
    static var likeMagazine = UIColor.fromRGB(163, green: 16, blue: 21)
    static var field = UIColor.fromRGB(117, green: 172, blue: 226)

    struct Chat {
      static var primary = UIColor.fromRGB(177, green: 244, blue: 116)
      static var secondary = UIColor.fromRGB(221, green: 226, blue: 230)
    }

    struct Segment {
      static var active = K.Color.buttonBg
      static var deactive = K.Color.button
    }

    struct Text {
      static var normal = K.Color.text
      static var strong = K.Color.Text.normal.darker()
      static var important = K.Color.important
    }

    static var palettes  = [
      UIColor.fromHex("EF2132", alpha: 1.0),
      UIColor.fromHex("FF864C", alpha: 1.0),
      UIColor.fromHex("FFCC00", alpha: 1.0),
      UIColor.fromHex("88C425", alpha: 1.0),
      UIColor.fromHex("376BEC", alpha: 1.0),
      UIColor.fromHex("31B4E8", alpha: 1.0),
      UIColor.fromHex("B955FF", alpha: 1.0),
      UIColor.fromHex("6B1470", alpha: 1.0)
    ]
  }

  struct Sample {
    static var users = [String]()
    static var titles = [String]()
    static var images = [String]()
  }

//  struct Image {
//    static var seeds = ["membersbg", "01", "02"]
//  }

  struct Size {
    static var barButtonItem = K.BarButtonItem.cgSize
    struct Submit {
      static var size = K.Size.Text.normal
      static var height = K.Size.Submit.size * 2.5
    }

    struct Header {
      static var height: CGFloat = 60.em
    }

    struct Text {
      static var tiny = CGFloat(10).em
      static var small = CGFloat(11).em
      static var normal = CGFloat(12).em
      static var medium = CGFloat(14).em
      static var large = CGFloat(16).em
      static var huge = CGFloat(32).em
      static var title = K.Size.Text.medium
    }

    struct Padding {
      static var micro = CGFloat(6).em
      static var tiny = CGFloat(8).em
      static var small = CGFloat(10).em
      static var medium = CGFloat(12).em
      static var large = CGFloat(16).em
      static var great = CGFloat(24).em
      static var huge = CGFloat(32).em
      static var scrollspace = CGFloat(20).em
      static var block = K.Size.Padding.small
    }

    struct Segment {
      static var underline: CGFloat = 5.0
    }
  }

  struct Line {
    struct Color {
      static var horizontal: UIColor = UIColor.grayColor()
      static var vertical: UIColor = UIColor.grayColor().lighter()
    }
    static var size: CGFloat = 0.5.em
  }

  struct BarButtonItem {
    static var size: CGFloat = 18.em
    static var cgSize = CGSize(width: K.BarButtonItem.size, height: K.BarButtonItem.size)
    static var color = UIColor.darkGrayColor()
  }

  struct App {
    static var name = ""
  }

  struct Path {
    static var Documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    static var Tmp = NSTemporaryDirectory()
  }
}

struct ColorPalette {
  static var Red = UIColor(red: 1.0, green: 0.1491, blue: 0.0, alpha: 1.0)
  static var Green = UIColor(red: 0.0, green: 0.5628, blue: 0.3188, alpha: 1.0)
  static var Blue = UIColor(red: 0.0, green: 0.3285, blue: 0.5749, alpha: 1.0)

  struct Gray {
    static var Light = UIColor(white: 0.8374, alpha: 1.0)
    static var Medium = UIColor(white: 0.4756, alpha: 1.0)
    static var Dark = UIColor(white: 0.2605, alpha: 1.0)
  }
}

// Usage
//var red = ColorPalette.Red
//var darkGray = ColorPalette.Gray.Dark
