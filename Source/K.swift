//
//  K.swift


import Foundation

public struct K {

  public struct Prompt {
    public static var delay: Double = 3
  }

  public struct CSS {
    public static var style = ""
    public static var style2 = ""
  }

  public struct Api {
    public static var host = ""
    public static var production = ""
    public static var stage = ""
    public static var local = ""
    public static var cable = ""

    public static var prefix = "/api"

    public static var pushserver = "/user_devices"
    public static var pushserverSubscribe = ""
    public static var appID = ""
    public static var userToken = ""
    public static var deviceType = "iOS"
    public static var userTokenKey = "userToken"
    public static var deviceTokenKey = "deviceToken"
    public static var deviceNameKey = "deviceName"

    public static var timeFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    public static var shortDateFormat = "yyyy-MM-dd"
    //    public static var timeFormat = "yyyy-mm-dd hh:mm:ss UTC"

    public struct Resource {
      public static var signIn = "/users/sign_in"
      public static var signOut = "/users/sign_out"
      public static var signUp = "/users"
      public static var validateToken = "/validate-token"
    }

    public struct Response {
      public static var success = "success"
      public static var message = "alert"
      public static var data = "data"
    }
  }

  public struct Text {
    public static var finished = "✓"
    public struct MultiSelection {
      public static var seperator = "/"
    }
  }

  public struct Message {
    public static var colors = [UIColor.fromRGB(73, green: 173, blue: 199), UIColor.fromRGB(158, green: 0, blue: 52).lighter(), UIColor.fromRGB(153, green: 130, blue: 0)]
  }

  public struct Font {
    public static var number = "HelveticaNeue-UltraLight"
    public static var ultraLight = "HelveticaNeue-UltraLight"
    public static var icon = ""
  }

  public struct Badge {
    public static var color = UIColor.white
    public static var backgroundColor = UIColor.red
    public static var size: CGFloat = 14
  }

  public struct Icons {
    public static var check = "\u{e800}"
    public static var angleRight = "\u{e808}"
    public static var close = "\u{e811}"
  }

  public struct Color {
    public static var tabBar = UIColor.gray
    public static var tabBarBackgroundColor = UIColor.white

    public static var navigator = UIColor.fromRGB(255, green: 255, blue: 255)
    public static var heart = UIColor.fromRGB(186, green: 50, blue: 133)
    public static var rating = UIColor.fromRGB(241, green: 209, blue: 0)
    public static var ratings = [UIColor.fromRGB(43, green: 97, blue: 172), UIColor.fromRGB(182, green: 56, blue: 130), UIColor.fromRGB(242, green: 208, blue: 0)]
    public static var body = UIColor.fromRGB(232, green: 232, blue: 232)
    public static var table = UIColor.fromRGB(232, green: 232, blue: 232)
    public static var collectionView = K.Color.body
    public static var buttonBg = UIColor.fromRGB(38, green: 92, blue: 170)
    public static var button = UIColor.fromRGB(240, green: 240, blue: 240)
    public static var barButtonItem = K.BarButtonItem.color
    public static var indicator = UIColor.fromRGB(226, green: 53, blue: 0)
    public static var cartBg = UIColor.fromRGB(116, green: 166, blue: 221)
    public static var border = K.Color.body.darker().darker()
    public static var dark = UIColor.black
    public static var light = UIColor.gray.darker()
    public static var popup = UIColor.white
    public static var checked = K.Color.buttonBg
    public static var unchecked = UIColor.lightGray
    public static var text = UIColor.darkGray//.darker()
    public static var facebook = UIColor.fromHex("3B5998")
    public static var google = UIColor.fromRGB(203, green: 52, blue: 37)
    public static var tip = UIColor.fromRGB(166, green: 0, blue: 21)
    public static var cell = UIColor.fromRGB(255, green: 255, blue: 255)
    public static var important = UIColor.fromRGB(186, green: 63, blue: 45)
    public static var nonImportant = UIColor.lightGray
    public static var image = UIColor.white
    public static var likeMagazine = UIColor.fromRGB(163, green: 16, blue: 21)
    public static var field = UIColor.fromRGB(117, green: 172, blue: 226)

    public static var selectOptionChecked = UIColor.yellow

    public struct Chat {
      public static var primary = UIColor.fromRGB(177, green: 244, blue: 116)
      public static var secondary = UIColor.fromRGB(221, green: 226, blue: 230)
    }

    public struct Alert {
      public static var color = UIColor.white
      public static var backgroundColor = UIColor.fromHex("008cc9")
    }

    public struct Segment {
      public static var active = K.Color.buttonBg
      public static var deactive = K.Color.button
    }

    public struct Text {
      public static var normal = K.Color.text
      public static var strong = K.Color.Text.normal.darker()
      public static var important = K.Color.important
    }

    public static var palettes  = [
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

  public struct Sample {
    public static var users = [String]()
    public static var titles = [String]()
    public static var images = [String]()
  }

  public struct Image {
    public static var jpegCompression: CGFloat = 0.2
  }

  public struct Size {
    public static var barButtonItem = K.BarButtonItem.cgSize
    public struct Submit {
      public static var size = K.Size.Text.normal
      public static var height = K.Size.Submit.size * 2.5
    }

    public struct ListButton {
      public static var height = 50.cgFloat
    }

    public struct Input {
      public static var height = 40.cgFloat
      public static var padding = 20.cgFloat
    }

    public struct Header {
      public static var height: CGFloat = 60.em
    }

    public struct Text {
      public static var tiny = CGFloat(10).em
      public static var small = CGFloat(11).em
      public static var normal = CGFloat(12).em
      public static var medium = CGFloat(14).em
      public static var large = CGFloat(16).em
      public static var huge = CGFloat(32).em
      public static var title = K.Size.Text.medium
    }

    public struct Padding {
      public static var micro = CGFloat(6).em
      public static var tiny = CGFloat(8).em
      public static var small = CGFloat(10).em
      public static var medium = CGFloat(12).em
      public static var large = CGFloat(16).em
      public static var great = CGFloat(24).em
      public static var huge = CGFloat(32).em
      public static var scrollspace = CGFloat(20).em
      public static var block = K.Size.Padding.small
    }

    public struct Segment {
      public static var underline: CGFloat = 5.0
    }
  }

  public struct Line {
    public struct Color {
      public static var horizontal: UIColor = UIColor.fromRGB(232, green: 232, blue: 232)
      public static var vertical: UIColor = UIColor.fromRGB(232, green: 232, blue: 232)
    }
    public static var size: CGFloat = 0.5.em
  }

  public struct BarButtonItem {
    public static var size: CGFloat = 18.em
    public static var cgSize = CGSize(width: K.BarButtonItem.size, height: K.BarButtonItem.size)
    public static var color = UIColor.darkGray
  }

  public struct App {
    public static var name = ""
    public static var mode = "stage" // "production"
  }

  public struct Path {
    public static var Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    public static var Tmp = NSTemporaryDirectory()
  }
}

public struct ColorPalette {
  public static var Red = UIColor(red: 1.0, green: 0.1491, blue: 0.0, alpha: 1.0)
  public static var Green = UIColor(red: 0.0, green: 0.5628, blue: 0.3188, alpha: 1.0)
  public static var Blue = UIColor(red: 0.0, green: 0.3285, blue: 0.5749, alpha: 1.0)

  public struct Gray {
    public static var Light = UIColor(white: 0.8374, alpha: 1.0)
    public static var Medium = UIColor(white: 0.4756, alpha: 1.0)
    public static var Dark = UIColor(white: 0.2605, alpha: 1.0)
  }
}

// Usage
//var red = ColorPalette.Red
//var darkGray = ColorPalette.Gray.Dark
