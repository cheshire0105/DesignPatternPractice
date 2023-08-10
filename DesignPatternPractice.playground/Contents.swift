
/*:
 # 1. Singleton 패턴 ( 생성 패턴 )
 
 전역적으로 로깅 기능을 제공하는 Logger 클래스 - 생성 패턴 中 싱글톤 패턴
 
 ## 목적
 클래스의 인스턴스가 단 하나만 생성되도록 보장하며, 그 인스턴스에 전역적으로 접근할 수 있게 해줍니다.
 
 ## 작동 방식
 생성자를 private으로 설정하여 클래스 외부에서의 인스턴스 생성을 방지합니다.
 static 변수를 통해 클래스 내부에서 유일한 인스턴스를 생성하고 저장합니다.
 이 인스턴스에 접근하기 위한 공개적인 방법으로 static 변수나 메서드를 제공합니다.
 
 ## 예시
 위의 Logger 클래스에서는 shared라는 static 변수를 통해 유일한 Logger 인스턴스에 접근할 수 있습니다.
 */


class Logger {
    // 'shared'는 Logger의 인스턴스를 저장하며, 이 인스턴스는 프로그램 내에서 유일합니다.
    static let shared = Logger()
    // 'private init()'을 통해 Logger 클래스 외부에서 새로운 인스턴스를 생성하는 것을 방지합니다.
    private init() {}
    // 로그 메시지를 출력하는 메서드
    func logMessage(_ message: String) {
        print("[LOG]: \(message)")
    }
}

/*:
 # 2. Decorator 패턴 (구조 패턴)
 
 음료와 그 음료에 추가할 수 있는 옵션(예: 휘핑 크림)을 정의 - 구조 패턴 中 데코레이트 패턴
 
 ## 목적
 기존 객체에 동적으로 새로운 기능을 추가하는 패턴입니다.
 상속을 활용하여 객체의 기능을 확장하는 대신, 데코레이터 패턴을 사용하여 유연하게 객체의 기능을 확장할 수 있습니다.
 
 ## 작동 방식
 기본 객체와 데코레이터 객체는 동일한 인터페이스를 공유합니다.
 데코레이터 클래스는 기본 객체에 대한 참조를 유지하면서 해당 객체에 추가적인 기능을 제공합니다.
 데코레이터는 기본 객체의 메서드를 호출하고, 그 결과에 추가적인 기능을 수행하여 반환합니다.
 
 ## 예시
 코드에서 Beverage 인터페이스는 기본 음료를 나타냅니다.
 WhipDecorator 클래스는 해당 인터페이스를 구현하면서 Beverage 객체를 내부에 포함하고 있습니다.
 이렇게 하면 기본 음료의 기능에 휘핑 크림 추가라는 기능을 덧붙일 수 있습니다.
 */
protocol Beverage {
    func cost() -> Double
    func description() -> String
}
class Americano: Beverage {
    // 아메리카노의 가격과 설명을 반환
    func cost() -> Double { return 2.0 }
    func description() -> String { return "Americano" }
}
class WhipDecorator: Beverage {
    // 음료에 대한 참조를 저장합니다. 이를 통해 기존 음료에 추가 기능을 제공합니다.
    let beverage: Beverage
    init(_ beverage: Beverage) { self.beverage = beverage }
    // 휘핑 크림의 가격을 추가하여 총 가격을 반환합니다.
    func cost() -> Double { return beverage.cost() + 0.5 }
    // 기존 음료의 설명에 "with Whip"을 추가하여 반환합니다.
    func description() -> String { return beverage.description() + " with Whip" }
}

/*:
 # 3. Observer 패턴 (행동 패턴)
 
 음료 제조기와 그 음료를 기다리는 고객을 정의 - 행동 패턴 中 옵저버 패턴
 
 ## 목적
 객체 간의 일대다의 의존 관계를 정의하여, 한 객체의 상태가 변경될 때 모든 의존자에게 알림을 전송하도록 합니다.
 
 ## 작동 방식
 Subject: 상태가 변경될 수 있는 객체입니다. Observer 객체를 추가, 삭제, 알림을 전송하는 메서드를 포함합니다.
 Observer: Subject의 상태 변경을 관찰하는 객체입니다.
 Subject의 상태가 변경될 때 알림을 받는 인터페이스를 제공합니다.
 Subject의 상태가 변경되면, 모든 Observer에게 알림을 전송합니다.
 
 ## 예시
 코드에서 BeverageMaker 클래스는 Subject 역할을 하며, 음료가 준비되면 모든 관찰자에게 알림을 전송합니다.
 Customer 클래스는 Observer 역할을 하며, 음료가 준비되었을 때의 알림을 받아 처리합니다.
 */

class BeverageMaker {
    // 음료 준비 알림을 받을 모든 관찰자(Observer)를 저장합니다.
    var observers = [BeverageObserver]()
    // 관찰자를 추가하는 메서드
    func addObserver(_ observer: BeverageObserver) { observers.append(observer) }
    // 음료가 준비되었을 때 관찰자들에게 알림을 전송하는 메서드
    func beverageIsReady(_ beverage: Beverage) {
        // 음료가 준비되었다는 로그 메시지를 출력합니다.
        Logger.shared.logMessage("Beverage \(beverage.description()) has been made.")
        // 모든 관찰자에게 음료 준비 알림을 전송합니다.
        observers.forEach { $0.notify(beverage) }
    }
}
// BeverageObserver 프로토콜은 음료 준비 알림을 받을 수 있는 객체가 가져야 할 인터페이스를 정의합니다. - 음료가 준비 되면 알람을 보내는 역할을 한다.
protocol BeverageObserver {
    func notify(_ beverage: Beverage)
}


class Customer: BeverageObserver {
    let name: String
    init(name: String) { self.name = name }
    // 음료 준비 알림을 받았을 때 호출되는 메서드
    func notify(_ beverage: Beverage) {
        print("\(name) received the \(beverage.description())")
        // 고객이 음료를 받았다는 로그 메시지를 출력합니다.
        Logger.shared.logMessage("\(name) has received the beverage.")
    }
}

// 사용 예시
let customer1 = Customer(name: "John")
let customer2 = Customer(name: "Alice")
let beverageMaker = BeverageMaker()
// John과 Alice 고객을 음료 제조기의 관찰자로 추가합니다.
beverageMaker.addObserver(customer1)
beverageMaker.addObserver(customer2)
// 아메리카노에 휘핑 크림을 추가한 음료를 생성합니다.
let americanoWithWhip = WhipDecorator(Americano())
// 음료 제조기에게 음료가 준비되었다고 알립니다.
beverageMaker.beverageIsReady(americanoWithWhip)
