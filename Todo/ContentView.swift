import SwiftUI
import Amplify

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContentView: View {
    
    var body: some View {
        Text("Hello, World!")
            .task {
                await performOnAppear()
            }
    }

    func performOnAppear() async {
        await subscribeTodos()
    }
    
    func subscribeTodos() async {
      do {
          let mutationEvents = Amplify.DataStore.observe(Todo.self)
          for try await mutationEvent in mutationEvents {
              print("Subscription got this value: \(mutationEvent)")
              do {
                  let todo = try mutationEvent.decodeModel(as: Todo.self)
                  
                  switch mutationEvent.mutationType {
                  case "create":
                      print("Created: \(todo)")
                  case "update":
                      print("Updated: \(todo)")
                  case "delete":
                      print("Deleted: \(todo)")
                  default:
                      break
                  }
              } catch {
                  print("Model could not be decoded: \(error)")
              }
          }
      } catch {
          print("Unable to observe mutation events")
      }
    }
}
