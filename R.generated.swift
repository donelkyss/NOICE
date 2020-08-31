//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `user.png`.
    static let userPng = Rswift.FileResource(bundle: R.hostingBundle, name: "user", pathExtension: "png")
    
    /// `bundle.url(forResource: "user", withExtension: "png")`
    static func userPng(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.userPng
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 11 images.
  struct image {
    /// Image `background`.
    static let background = Rswift.ImageResource(bundle: R.hostingBundle, name: "background")
    /// Image `closeUser`.
    static let closeUser = Rswift.ImageResource(bundle: R.hostingBundle, name: "closeUser")
    /// Image `close`.
    static let close = Rswift.ImageResource(bundle: R.hostingBundle, name: "close")
    /// Image `fotoperfil`.
    static let fotoperfil = Rswift.ImageResource(bundle: R.hostingBundle, name: "fotoperfil")
    /// Image `help`.
    static let help = Rswift.ImageResource(bundle: R.hostingBundle, name: "help")
    /// Image `launch`.
    static let launch = Rswift.ImageResource(bundle: R.hostingBundle, name: "launch")
    /// Image `login`.
    static let login = Rswift.ImageResource(bundle: R.hostingBundle, name: "login")
    /// Image `menu`.
    static let menu = Rswift.ImageResource(bundle: R.hostingBundle, name: "menu")
    /// Image `msg`.
    static let msg = Rswift.ImageResource(bundle: R.hostingBundle, name: "msg")
    /// Image `user`.
    static let user = Rswift.ImageResource(bundle: R.hostingBundle, name: "user")
    /// Image `users`.
    static let users = Rswift.ImageResource(bundle: R.hostingBundle, name: "users")
    
    /// `UIImage(named: "background", bundle: ..., traitCollection: ...)`
    static func background(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.background, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "close", bundle: ..., traitCollection: ...)`
    static func close(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.close, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "closeUser", bundle: ..., traitCollection: ...)`
    static func closeUser(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.closeUser, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "fotoperfil", bundle: ..., traitCollection: ...)`
    static func fotoperfil(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.fotoperfil, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "help", bundle: ..., traitCollection: ...)`
    static func help(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.help, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "launch", bundle: ..., traitCollection: ...)`
    static func launch(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.launch, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "login", bundle: ..., traitCollection: ...)`
    static func login(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.login, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "menu", bundle: ..., traitCollection: ...)`
    static func menu(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.menu, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "msg", bundle: ..., traitCollection: ...)`
    static func msg(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.msg, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "user", bundle: ..., traitCollection: ...)`
    static func user(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.user, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "users", bundle: ..., traitCollection: ...)`
    static func users(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.users, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `UserTableViewCell`.
    static let userTableViewCell = _R.nib._UserTableViewCell()
    
    /// `UINib(name: "UserTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.userTableViewCell) instead")
    static func userTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.userTableViewCell)
    }
    
    static func userTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UserTableViewCell? {
      return R.nib.userTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UserTableViewCell
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `UserCell`.
    static let userCell: Rswift.ReuseIdentifier<UserCollectionViewCell> = Rswift.ReuseIdentifier(identifier: "UserCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 5 localization tables.
  struct string {
    /// This `R.string.infoPlist` struct is generated, and contains static references to 2 localization keys.
    struct infoPlist {
      /// es translation: 2Brice requiere acceder a la cámara de su dispositivo para tomar su foto de perfil.
      /// 
      /// Locales: es
      static let nsCameraUsageDescription = Rswift.StringResource(key: "NSCameraUsageDescription", tableName: "InfoPlist", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: 2Brice requiere acceder a su localización para mostrar los usuarios conectados cerca de su posición.
      /// 
      /// Locales: es
      static let nsLocationWhenInUseUsageDescription = Rswift.StringResource(key: "NSLocationWhenInUseUsageDescription", tableName: "InfoPlist", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      
      /// es translation: 2Brice requiere acceder a la cámara de su dispositivo para tomar su foto de perfil.
      /// 
      /// Locales: es
      static func nsCameraUsageDescription(_: Void = ()) -> String {
        return NSLocalizedString("NSCameraUsageDescription", tableName: "InfoPlist", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: 2Brice requiere acceder a su localización para mostrar los usuarios conectados cerca de su posición.
      /// 
      /// Locales: es
      static func nsLocationWhenInUseUsageDescription(_: Void = ()) -> String {
        return NSLocalizedString("NSLocationWhenInUseUsageDescription", tableName: "InfoPlist", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
    struct launchScreen {
      fileprivate init() {}
    }
    
    /// This `R.string.localizable` struct is generated, and contains static references to 0 localization keys.
    struct localizable {
      fileprivate init() {}
    }
    
    /// This `R.string.main` struct is generated, and contains static references to 27 localization keys.
    struct main {
      /// es translation: Bloquear
      /// 
      /// Locales: es
      static let du257WBNormalTitle = Rswift.StringResource(key: "3du-25-7WB.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Buscando Usuarios...
      /// 
      /// Locales: es
      static let vWtE2WebText = Rswift.StringResource(key: "vWt-E2-web.text", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Buscando...
      /// 
      /// Locales: es
      static let byz38T0rTitle = Rswift.StringResource(key: "BYZ-38-t0r.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Button
      /// 
      /// Locales: es
      static let vTkYAXYpNormalTitle = Rswift.StringResource(key: "vTk-yA-XYp.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Cargando...
      /// 
      /// Locales: es
      static let qXcIaTA2Text = Rswift.StringResource(key: "QXc-Ia-tA2.text", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Cerrar Sesion
      /// 
      /// Locales: es
      static let nZqJqL0FNormalTitle = Rswift.StringResource(key: "nZq-Jq-L0F.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Chat
      /// 
      /// Locales: es
      static let cexBi2NjTitle = Rswift.StringResource(key: "Cex-bi-2Nj.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Chat
      /// 
      /// Locales: es
      static let pdvycgdcTitle = Rswift.StringResource(key: "PDV-YC-gDC.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Click sobre la foto para chatear o desplaza para ocultar y bloquear.
      /// 
      /// Locales: es
      static let ealHZVB9Text = Rswift.StringResource(key: "Eal-HZ-VB9.text", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Compartir
      /// 
      /// Locales: es
      static let plS7Tq1NormalTitle = Rswift.StringResource(key: "8Pl-s7-Tq1.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Conectados
      /// 
      /// Locales: es
      static let boh5gGzfTitle = Rswift.StringResource(key: "BOH-5g-gzf.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Conectados
      /// 
      /// Locales: es
      static let mVM3KJxsTitle = Rswift.StringResource(key: "mVM-3K-jxs.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Conectados
      /// 
      /// Locales: es
      static let pk9LhSjnTitle = Rswift.StringResource(key: "Pk9-lh-Sjn.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Conectados
      /// 
      /// Locales: es
      static let ucBfETitle = Rswift.StringResource(key: "604-uc-BfE.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Conectados
      /// 
      /// Locales: es
      static let xRWVJrTitle = Rswift.StringResource(key: "33x-rW-vJr.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Editar Foto
      /// 
      /// Locales: es
      static let qkoQk2OsNormalTitle = Rswift.StringResource(key: "QKO-Qk-2Os.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Item
      /// 
      /// Locales: es
      static let kgRIFLSvTitle = Rswift.StringResource(key: "KgR-iF-lSv.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Item
      /// 
      /// Locales: es
      static let lhtRdLsITitle = Rswift.StringResource(key: "lht-rd-lsI.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Item
      /// 
      /// Locales: es
      static let mfnS2TupTitle = Rswift.StringResource(key: "Mfn-S2-tup.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Item
      /// 
      /// Locales: es
      static let momZmVRSTitle = Rswift.StringResource(key: "MOM-Zm-vRS.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Item
      /// 
      /// Locales: es
      static let qcWQ7OjnTitle = Rswift.StringResource(key: "qcW-q7-Ojn.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Login
      /// 
      /// Locales: es
      static let fdmNIOhwTitle = Rswift.StringResource(key: "fdm-NI-ohw.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Login with:
      /// 
      /// Locales: es
      static let bsXNZ1qvText = Rswift.StringResource(key: "bsX-NZ-1qv.text", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Menu
      /// 
      /// Locales: es
      static let as4GgJ3cTitle = Rswift.StringResource(key: "As4-gg-j3c.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Menu
      /// 
      /// Locales: es
      static let um9YsBX5Title = Rswift.StringResource(key: "UM9-Ys-bX5.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: Perfil
      /// 
      /// Locales: es
      static let qGZUk4Title = Rswift.StringResource(key: "24q-gZ-uk4.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      /// es translation: usuarios
      /// 
      /// Locales: es
      static let kz2T2GMxTitle = Rswift.StringResource(key: "kz2-T2-GMx.title", tableName: "Main", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      
      /// es translation: Bloquear
      /// 
      /// Locales: es
      static func du257WBNormalTitle(_: Void = ()) -> String {
        return NSLocalizedString("3du-25-7WB.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Buscando Usuarios...
      /// 
      /// Locales: es
      static func vWtE2WebText(_: Void = ()) -> String {
        return NSLocalizedString("vWt-E2-web.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Buscando...
      /// 
      /// Locales: es
      static func byz38T0rTitle(_: Void = ()) -> String {
        return NSLocalizedString("BYZ-38-t0r.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Button
      /// 
      /// Locales: es
      static func vTkYAXYpNormalTitle(_: Void = ()) -> String {
        return NSLocalizedString("vTk-yA-XYp.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Cargando...
      /// 
      /// Locales: es
      static func qXcIaTA2Text(_: Void = ()) -> String {
        return NSLocalizedString("QXc-Ia-tA2.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Cerrar Sesion
      /// 
      /// Locales: es
      static func nZqJqL0FNormalTitle(_: Void = ()) -> String {
        return NSLocalizedString("nZq-Jq-L0F.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Chat
      /// 
      /// Locales: es
      static func cexBi2NjTitle(_: Void = ()) -> String {
        return NSLocalizedString("Cex-bi-2Nj.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Chat
      /// 
      /// Locales: es
      static func pdvycgdcTitle(_: Void = ()) -> String {
        return NSLocalizedString("PDV-YC-gDC.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Click sobre la foto para chatear o desplaza para ocultar y bloquear.
      /// 
      /// Locales: es
      static func ealHZVB9Text(_: Void = ()) -> String {
        return NSLocalizedString("Eal-HZ-VB9.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Compartir
      /// 
      /// Locales: es
      static func plS7Tq1NormalTitle(_: Void = ()) -> String {
        return NSLocalizedString("8Pl-s7-Tq1.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Conectados
      /// 
      /// Locales: es
      static func boh5gGzfTitle(_: Void = ()) -> String {
        return NSLocalizedString("BOH-5g-gzf.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Conectados
      /// 
      /// Locales: es
      static func mVM3KJxsTitle(_: Void = ()) -> String {
        return NSLocalizedString("mVM-3K-jxs.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Conectados
      /// 
      /// Locales: es
      static func pk9LhSjnTitle(_: Void = ()) -> String {
        return NSLocalizedString("Pk9-lh-Sjn.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Conectados
      /// 
      /// Locales: es
      static func ucBfETitle(_: Void = ()) -> String {
        return NSLocalizedString("604-uc-BfE.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Conectados
      /// 
      /// Locales: es
      static func xRWVJrTitle(_: Void = ()) -> String {
        return NSLocalizedString("33x-rW-vJr.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Editar Foto
      /// 
      /// Locales: es
      static func qkoQk2OsNormalTitle(_: Void = ()) -> String {
        return NSLocalizedString("QKO-Qk-2Os.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Item
      /// 
      /// Locales: es
      static func kgRIFLSvTitle(_: Void = ()) -> String {
        return NSLocalizedString("KgR-iF-lSv.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Item
      /// 
      /// Locales: es
      static func lhtRdLsITitle(_: Void = ()) -> String {
        return NSLocalizedString("lht-rd-lsI.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Item
      /// 
      /// Locales: es
      static func mfnS2TupTitle(_: Void = ()) -> String {
        return NSLocalizedString("Mfn-S2-tup.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Item
      /// 
      /// Locales: es
      static func momZmVRSTitle(_: Void = ()) -> String {
        return NSLocalizedString("MOM-Zm-vRS.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Item
      /// 
      /// Locales: es
      static func qcWQ7OjnTitle(_: Void = ()) -> String {
        return NSLocalizedString("qcW-q7-Ojn.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Login
      /// 
      /// Locales: es
      static func fdmNIOhwTitle(_: Void = ()) -> String {
        return NSLocalizedString("fdm-NI-ohw.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Login with:
      /// 
      /// Locales: es
      static func bsXNZ1qvText(_: Void = ()) -> String {
        return NSLocalizedString("bsX-NZ-1qv.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Menu
      /// 
      /// Locales: es
      static func as4GgJ3cTitle(_: Void = ()) -> String {
        return NSLocalizedString("As4-gg-j3c.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Menu
      /// 
      /// Locales: es
      static func um9YsBX5Title(_: Void = ()) -> String {
        return NSLocalizedString("UM9-Ys-bX5.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: Perfil
      /// 
      /// Locales: es
      static func qGZUk4Title(_: Void = ()) -> String {
        return NSLocalizedString("24q-gZ-uk4.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      /// es translation: usuarios
      /// 
      /// Locales: es
      static func kz2T2GMxTitle(_: Void = ()) -> String {
        return NSLocalizedString("kz2-T2-GMx.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    /// This `R.string.userTableViewCell` struct is generated, and contains static references to 1 localization keys.
    struct userTableViewCell {
      /// es translation: chat   >
      /// 
      /// Locales: es
      static let bmi29P0bText = Rswift.StringResource(key: "bmi-29-P0b.text", tableName: "UserTableViewCell", bundle: R.hostingBundle, locales: ["es"], comment: nil)
      
      /// es translation: chat   >
      /// 
      /// Locales: es
      static func bmi29P0bText(_: Void = ()) -> String {
        return NSLocalizedString("bmi-29-P0b.text", tableName: "UserTableViewCell", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _UserTableViewCell.validate()
    }
    
    struct _UserTableViewCell: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "UserTableViewCell"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> UserTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? UserTableViewCell
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "conected", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'conected' is used in nib 'UserTableViewCell', but couldn't be loaded.") }
        if UIKit.UIImage(named: "msg", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'msg' is used in nib 'UserTableViewCell', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try main.validate()
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "launch", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'launch' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let chat = StoryboardViewControllerResource<ChatViewController>(identifier: "Chat")
      let inicioView = StoryboardViewControllerResource<InicioController>(identifier: "InicioView")
      let loginView = StoryboardViewControllerResource<LoginController>(identifier: "loginView")
      let name = "Main"
      let profileView = StoryboardViewControllerResource<ProfileController>(identifier: "ProfileView")
      let usersConnected = StoryboardViewControllerResource<UsersConnected>(identifier: "UsersConnected")
      
      func chat(_: Void = ()) -> ChatViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: chat)
      }
      
      func inicioView(_: Void = ()) -> InicioController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: inicioView)
      }
      
      func loginView(_: Void = ()) -> LoginController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginView)
      }
      
      func profileView(_: Void = ()) -> ProfileController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: profileView)
      }
      
      func usersConnected(_: Void = ()) -> UsersConnected? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: usersConnected)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "background", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'background' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "close", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'close' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "closeUser", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'closeUser' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "help", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'help' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "login", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'login' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "menu", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'menu' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "msg", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'msg' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "user.png", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'user.png' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "users", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'users' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.main().chat() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'chat' could not be loaded from storyboard 'Main' as 'ChatViewController'.") }
        if _R.storyboard.main().inicioView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'inicioView' could not be loaded from storyboard 'Main' as 'InicioController'.") }
        if _R.storyboard.main().profileView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'profileView' could not be loaded from storyboard 'Main' as 'ProfileController'.") }
        if _R.storyboard.main().usersConnected() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'usersConnected' could not be loaded from storyboard 'Main' as 'UsersConnected'.") }
        if _R.storyboard.main().loginView() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'loginView' could not be loaded from storyboard 'Main' as 'LoginController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
