import Foundation
import CoreGraphics

extension CGPoint : AdditiveArithmetic{
    
    //Soma
    public static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    //Subtração
    public static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return left + (-right)
    }
    
    //Inverter
    public static prefix func - (vector : CGPoint) -> CGPoint {
        return CGPoint(x: -vector.x, y: -vector.y)
    }
    
    //Somar nele mesmo
    public static func += (left :inout CGPoint, right : CGPoint){
        left = left + right
    }
    
    //Subtrair nele mesmo
    public static func -= (left : inout CGPoint, right : CGPoint){
        left = left - right
    }

}

infix operator * : MultiplicationPrecedence
infix operator / : MultiplicationPrecedence
infix operator • : MultiplicationPrecedence

extension CGPoint {
    
    //Mult escalar esquerda
    public static func *(left: CGFloat, right: CGPoint) -> CGPoint{
        return CGPoint(x: left * right.x, y: left * right.y)
    }
    
    //Mult escalar direita
    public static func *(left: CGPoint, right: CGFloat) -> CGPoint{
        return CGPoint(x: left.x * right, y: left.y * right)
    }
    
    //Divisão escalar
    public static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        if right == 0 {
            return CGPoint(x: left.x, y: left.y)
        } else {
            return CGPoint(x: left.x / right, y: left.y / right)
        }
        
    }
    
    //Dividir nele mesmo
    public static func /= (left: inout CGPoint, right: CGFloat) -> CGPoint {
        guard right != 0 else { fatalError("Division by zero") }
        return CGPoint(x: left.x / right, y: left.y / right)
    }
    
    //Multiplicar nele mesmo
    public static func *= (left: inout CGPoint, right: CGFloat) {
        left = left * right
    }
}

extension CGPoint {
    
    //Vetor normalizado
    public var normalized : CGPoint {
        return CGPoint(x: self.x / self.magnitude, y: self.y / self.magnitude)
    }
    
    //Modulo
    public var magnitude : CGFloat {
        return sqrt(self•self)
    }
    
    
    //Produto interno
    public static func •(left : CGPoint, right: CGPoint) -> CGFloat{
        return left.x * right.x + left.y * right.y
    }
    
    
    //Distância entre vetores
    public func distance(to vector: CGPoint) -> CGFloat {
        return (self - vector).magnitude
    }
    
    //Ângulo entre vetores
    public func angle(to vector: CGPoint) -> CGFloat {
        return acos(self.normalized • vector.normalized)
    }
}


