import SwiftUI
import MeshingKit
import Inject

/// A view that displays a list of gradient templates and allows full-screen viewing.
struct GradientSamplesView: View {
  @ObserveInjection var inject
  @State private var selectedTemplate: GradientTemplate?

  var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Size 2 Templates")) {
          ForEach(GradientTemplateSize2.allCases, id: \.self) { template in
            Button(template.name) {
              selectedTemplate = .size2(template)
            }
          }
        }

        Section(header: Text("Size 3 Templates")) {
          ForEach(GradientTemplateSize3.allCases, id: \.self) { template in
            Button(template.name) {
              selectedTemplate = .size3(template)
            }
          }
        }

        Section(header: Text("Size 4 Templates")) {
          ForEach(GradientTemplateSize4.allCases, id: \.self) { template in
            Button(template.name) {
              selectedTemplate = .size4(template)
            }
          }
        }
      }
      .navigationTitle("Gradient Templates")
    }
    .sheet(item: $selectedTemplate) { template in
      FullScreenGradientView(template: template)
    }
    .enableInjection()
  }
}

/// An enumeration representing the different types of gradient templates.
enum GradientTemplate: Identifiable {
  case size2(GradientTemplateSize2)
  case size3(GradientTemplateSize3)
  case size4(GradientTemplateSize4)

  var id: String {
    switch self {
      case .size2(let template): return "size2_\(template.rawValue)"
      case .size3(let template): return "size3_\(template.rawValue)"
      case .size4(let template): return "size4_\(template.rawValue)"
    }
  }
}

/// A view that displays a full-screen version of a selected gradient template.
struct FullScreenGradientView: View {
  let template: GradientTemplate
  @Environment(\.presentationMode) var presentationMode
  @State private var showAnimation: Bool = false

  var body: some View {
    ZStack {
      gradientView

      VStack {
        Spacer()
        Toggle("Animate", isOn: $showAnimation)
          .padding()
          .background(Color.white.opacity(0.7))
          .cornerRadius(8)
        Button("Close") {
          presentationMode.wrappedValue.dismiss()
        }
        .padding(.bottom)
        .buttonStyle(.borderedProminent)
      }
    }
    .edgesIgnoringSafeArea(.all)
  }

  @ViewBuilder
  var gradientView: some View {
    switch template {
      case .size2(let size2Template):
        AnimatedMeshGradientView(
          gridSize: 2,
          showAnimation: $showAnimation,
          positions: size2Template.positions,
          colors: size2Template.colors,
          background: size2Template.background
        )
      case .size3(let size3Template):
        AnimatedMeshGradientView(
          gridSize: 3,
          showAnimation: $showAnimation,
          positions: size3Template.positions,
          colors: size3Template.colors,
          background: size3Template.background
        )
      case .size4(let size4Template):
        AnimatedMeshGradientView(
          gridSize: 4,
          showAnimation: $showAnimation,
          positions: size4Template.positions,
          colors: size4Template.colors,
          background: size4Template.background
        )
    }
  }
}

struct GradientSamplesView_Previews: PreviewProvider {
  static var previews: some View {
    GradientSamplesView()
  }
}