import RealityKit
#if os(iOS)
import UIKit
#endif

#if os(macOS)
import Cocoa
#endif


#if os(macOS)
public typealias LineEntityColor = NSColor
#else
public typealias LineEntityColor = UIColor
#endif

public class LineEntity: Entity {
    public var startPos: SIMD3<Float>
    public var endPos: SIMD3<Float>
    var color: LineEntityColor
    
    private func setLine() {
        let length = length(endPos - startPos)
        let mesh = MeshResource.generateBox(size: SIMD3<Float>(0.0001, length, 0.0001), cornerRadius: 0.0)
        
        
        var material = PhysicallyBasedMaterial()
        material.emissiveIntensity = 10000.0
        material.emissiveColor = PhysicallyBasedMaterial.EmissiveColor(color: color)
        
        self.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: [material])

        self.position = (endPos - startPos) / 2.0
        self.look(at: endPos, from: startPos, relativeTo: nil)
    }
    
    public required init(from startP: SIMD3<Float>, to endP: SIMD3<Float>, withColor: LineEntityColor = .green) {
        self.startPos = startP
        self.endPos = endP
        self.color = withColor
        
        super.init()
        
        setLine()

    }
    
    public required convenience init() {
        self.init(from: SIMD3<Float>(0, 0, 0), to: SIMD3<Float>(Float.ulpOfOne, Float.ulpOfOne, Float.ulpOfOne))
    }
}
