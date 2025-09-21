// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:graph_builder/node.dart';
import 'package:graph_builder/graph_view.dart';

import 'package:graph_builder/node_widget.dart';
void main() {
  runApp(const GraphBuilderApp());
}

class GraphBuilderApp extends StatelessWidget {
  const GraphBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Graph Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GraphBuilderHomePage(),
    );
  }
}

class GraphBuilderHomePage extends StatefulWidget {
  const GraphBuilderHomePage({super.key});

  @override
  State<GraphBuilderHomePage> createState() => _GraphBuilderHomePageState();
}

class _GraphBuilderHomePageState extends State<GraphBuilderHomePage> {
  int _nextNodeId = 1;
  late Node _rootNode;
  Node? _activeNode;

  @override
  void initState() {
    super.initState();
    // The app starts with a single root node with label "1".
    _rootNode = Node('${_nextNodeId++}');
    _activeNode = _rootNode;
  }

  void _addNode() {
    setState(() {
      // Add child nodes to the currently active node.
      if (_activeNode != null) {
        // Each added child node should have an incrementing number.
        final newNode = Node('${_nextNodeId++}');
        _activeNode!.children.add(newNode);
      }
    });
  }

  void _deleteNode(Node nodeToDelete) {
    setState(() {
      // Find and delete the node and its children.
      _deleteNodeRecursive(_rootNode, nodeToDelete);
      // After deletion, reset the active node if the deleted node was active.
      if (_activeNode == nodeToDelete) {
        _activeNode = _rootNode;
      }
    });
  }

  void _deleteNodeRecursive(Node parent, Node target) {
    // This is a helper method to find and remove the target node.
    // Deleting a parent node will delete all leaf nodes attached to it.
    parent.children.removeWhere((node) => node == target);
    for (var child in parent.children) {
      _deleteNodeRecursive(child, target);
    }
  }

  void _selectNode(Node node) {
    setState(() {
      // Select (activate) any node by tapping on it.
      // Once a node is active, newly added nodes should attach to it as children.
      _activeNode = node;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Builder'),
      ),
      body: Row(
        children: [
          // This will be your visual representation of the graph.
          Expanded(
            child: GraphView(
              root: _rootNode,
              activeNode: _activeNode,
              onNodeTap: _selectNode,
              onDelete: _deleteNode,
            ),
          ),
          // Simple UI for adding nodes.
          Column(
            children: [
              ElevatedButton(
                onPressed: _addNode,
                child: const Text('Add Node'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}