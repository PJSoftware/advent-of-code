use regex::Regex;
use std::collections::HashMap;

pub struct Tower {
  head: Link,
  node_links: HashMap<String,Link>,
}

type Link = Option<Box<Node>>;

struct Node {
  name: String,
  weight: i32,
  parent: Link,
  children: Vec<Link>,
}

impl Tower {
  pub fn new() -> Self {
    Tower { head: None, node_links: Default::default() }
  }

  pub fn import(&mut self, line: String) {
    let re = Regex::new(r"^([^ ]+) \(([0-9]+)\)(.*)$").unwrap();

    let Some(caps) = re.captures(&line) else {
      println!("line {} does not match expected pattern!", line);
      return
    };

    let name = caps[1].to_string();
    let weight = caps[2].parse::<i32>().unwrap();
    self.add_node(name, weight);

    if &caps[3] == "" { return }
    let list = caps[3].strip_prefix(" -> ").unwrap();
    let children = list.split(", ");
    for child in children {
      self.add_child(name, child.to_string());
    }

//       let list_children = 
//       let children = list_children.split(", ");
//       for child in children {
//         has_parent.insert(child.to_string(), true);
//       }


  }

  fn add_node(&mut self, name: String, weight: i32) {
    if self.node_links.contains_key(&name) { return };
    let link = new_node_link(name.clone(), weight);
    self.node_links.insert(name, link);
  }

  fn add_child(&mut self, parent: String, child: String) {
    let c_node = self.node_links.get_mut(&child).unwrap();
    // let p_node = self.node_links.get_mut(&parent).unwrap();
    let p_link = self.node_links.get_key_value(&parent).unwrap().1;

    c_node.unwrap().as_mut().parent = *p_link;
  }

}

fn new_node_link(name: String, weight: i32) -> Link {
  let new_node = Box::new(Node {
    name: name,
    weight: weight,
    parent: None,
    children: Default::default(),
  });
  Some(new_node)
}

// fn find_root(data: Vec<String>) -> String {
//   let mut has_parent: HashMap<String, bool> = HashMap::new();
  
//   for line in &data {
//     if !has_parent.contains_key(&caps[1].to_string()) {
//       has_parent.insert(caps[1].to_string(), false);
//     }
//   }

//   for (prog, hp) in has_parent {
//     if !hp {
//       return prog;
//     }
//   }
//   return "".to_string();
// }

#[cfg(test)]
mod test {
  use super::Tower;

  #[test]
  fn basics() {
    let _tower = Tower::new();
  }
}