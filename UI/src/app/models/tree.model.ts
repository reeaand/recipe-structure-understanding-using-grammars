import {Edge, Node} from '@swimlane/ngx-graph';

/**
 * Model for the ngx-graph compatible tree component
 */
export class Tree {
  public nodes: Node[];
  public links: Edge[];

  constructor(nodes, links) {
    this.nodes = nodes;
    this.links = links;
  }
}
