import 'package:flutter/material.dart';
import 'package:graph_builder/node.dart';
import 'package:graph_builder/node_widget.dart'; // Import the new widget

class GraphView extends StatelessWidget {
  final Node root;
  final Node? activeNode;
  final Function(Node) onNodeTap;
  final Function(Node) onDelete;

  const GraphView({
    super.key,
    required this.root,
    this.activeNode,
    required this.onNodeTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: _buildNode(root, isRoot: true),
    );
  }

  Widget _buildNode(Node node, {bool isRoot = false}) {
    final bool isActive = node == activeNode;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // This is the Node Widget itself
          NodeWidget(
            label: node.label,
            isActive: isActive,
            onTap: () => onNodeTap(node),
            onDelete: () => onDelete(node),
            isRoot: isRoot,
          ),
          // This is the line that connects the nodes visually
          if (node.children.isNotEmpty)
            Container(
              width: 2,
              color: Colors.grey,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
          // This displays the children nodes
          if (node.children.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: node.children.map((child) => _buildNode(child)).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}