/**
 * Model for the original tree structure
 */
export class Original {
  public level: string;
  public label: string;
  public value: string;
  public children?: Original[];
}
