> 相比于OC时代的完全没有命名空间，Swift可以通过巧妙的办法，实现几乎等同于命名空间的效果。

# 需求

现在我们希望为`UIColor`类增加一个扩展方法，根据其自身颜色生成图像`UIImage`。
在没有命名空间的时代，可能结果是这样子的：
```swift
let image = UIColor.blue.image
```
或者为避免与其它框架API同名，可能结果会变成这样子：
```swift
let image = UIColor.blue.jx_image
```
当然这种风格非常地OC。

那有没有优雅一点的办法来代替OC Style？比如能写成这样子就好了：

```swift
let image = UIColor.blue.jx.image
```

Swift3绕一下路，也是可以做到的。姑且把中间的`.jx`叫做命名空间(Namespace)，没错，抄了一下C#们的叫法。

# 定义命名空间

具体的做法通过扩展特定的协议来达到目的。
我们需要定义两个协议，其中一个是固定的写法：
```swift
/// 类型协议
protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

struct NamespaceWrapper<T>: TypeWrapperProtocol {
    let wrappedValue: T
    init(value: T) {
        self.wrappedValue = value
    }
}
```

另一个协议基本上也是固定的写法，只是根据我们的需要，更改其内的命名空间名字即可。
比如我需要一个名为`jx`的命名空间，就可以这样写：
```swift
/// 命名空间协议
protocol NamespaceWrappable {
    associatedtype WrapperType
    var jx: WrapperType { get }
    static var jx: WrapperType.Type { get }
}

extension NamespaceWrappable {
    var jx: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    static var jx: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}
```

需要什么样的命名空间，就把其中的`jx`改成你希望的名字。

# 使用命名空间

实际上我们需要扩展的类不是`UIColor`，而是协议。
这里分两步，第一步是让需要扩展的类遵循协议`NamespaceWrappable`：
```swift
extension UIColor: NamespaceWrappable {}
```

第二步是扩展协议`TypeWrapperProtocol`：
```swift
extension TypeWrapperProtocol where WrappedType == UIColor {
    /// 用自身颜色生成UIImage
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(wrappedValue.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}
```

在扩展的方法中，`self`代表的是协议，而不是目标扩展类。那要用到`self`怎么办？用`wrappedValue`吧，它就是我们的目标类/实例。

# 验证
现在可以愉快地玩耍了：
```swift
let image = UIColor.blue.jx.image
```

使用了命名空间后，还有一个优点就是可以利用Xcode的代码补全。

![Xcode代码补全](http://upload-images.jianshu.io/upload_images/2419179-7532c9e6518addba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

相比在打出`.im`后Xcode会弹出一大堆匹配到`im`两字母的方法，使用了命名空间后，点出`.jx.`时，Xcode就只会提示此命名空间内的方法/属性。特别是`String`和`UIView`这种有巨量方法的类，只要打出命名空间就可以快速过滤不需要的方法。
