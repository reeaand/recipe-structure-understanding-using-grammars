import {Original} from '../models/original.model';
import {Tree} from '../models/tree.model';
import {Edge, Node} from '@swimlane/ngx-graph';

export class DisplayConverter {

  private static nodes = [] as Node[];
  private static links = [] as Edge[];
  private static newId = 0;

  /**
   * Converts a tree in the original structure to ngx-graph form
   * @param json the original tree structure
   */
  public static jsonToDisplay(json: Original): Tree{
    DisplayConverter.nodes = [] as Node[];
    DisplayConverter.links = [] as Edge[];
    DisplayConverter.newId = 0;

    const node = DisplayConverter.makeNode(json, DisplayConverter.newId.toString());
    DisplayConverter.nodes.push(node);
    DisplayConverter.newId++;
    DisplayConverter.build(json, node);

    return new Tree(DisplayConverter.nodes, DisplayConverter.links);
  }

  /**
   * Males a link between two new nodes
   * @param sourceId the parent node's ID
   * @param targetId the child node's ID
   * @private
   */
  private static makeLink(sourceId: string, targetId: string): Edge {
    return {
      source: sourceId,
      target: targetId,
      label: ''
    };
  }

  /**
   * Makes a node
   * @param node the node to extract fields from
   * @param ID the id of the new node
   */
  private static makeNode(node: Original, ID: string): Node {
    return {
      id: ID,
      label: node.level,
      data: {
        label: node.label,
        value: node.value
      }
    };
  }

  /**
   * Builds the new tree for ngx-graph
   * @param current current node of original structure
   * @param transformed current node in the new format
   */
  private static build(current: Original, transformed: Node): void {
    if (current.children === undefined) { return; }
    for (const child of current.children) {
      const node = DisplayConverter.makeNode(child, DisplayConverter.newId.toString());
      const link = DisplayConverter.makeLink(transformed.id, node.id);
      DisplayConverter.nodes.push(node);
      DisplayConverter.links.push(link);
      DisplayConverter.newId++;
      DisplayConverter.build(child, node);
    }
  }

}
