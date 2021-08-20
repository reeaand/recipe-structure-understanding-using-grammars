import { Component, OnInit } from '@angular/core';
import {Original} from '../../models/original.model';
import {Tree} from '../../models/tree.model';
import {DisplayConverter} from '../../utils/display-converter';
import {fillColors, strokeColors} from '../../utils/symbols.utils';
import {RecipeService} from '../../services/recipe.service';

@Component({
  selector: 'app-tree-display',
  templateUrl: './tree-display.component.html',
  styleUrls: ['./tree-display.component.scss']
})
export class TreeDisplayComponent implements OnInit {

  constructor(public recipeService: RecipeService) {
    this.text = 'Beat 3 large eggs into a bowl and add salt. Cut a red onion, if desired, and put it in the mix.';
    this.findDisplay(this.text);
  }

  public data: Original; // the original recipe tree object
  public tree: Tree; // the ngx-graph adapted tree object

  public strokeType = strokeColors;
  public fillType = fillColors;

  public eos = '.;!?';
  public text = '';

  ngOnInit(): void {
  }

  /**
   * Detect a new sentence and request a new tree
   * @param element textarea component
   */
  public detectSentence(element): void {
      let val = element.value;
      val = val.replace(/\\r?\\n|\\r/g, '');
      val = val.trim();
      console.log(val);
      if (this.eos.indexOf(val[val.length - 1]) === -1) {
          val += '.';
      }
      this.findDisplay(val);
  }

  /**
   * Request the recipe tree for a text
   * @param value the recipe text
   */
  public findDisplay(value: string): void {
    this.recipeService.getJSON(value).subscribe(
      (data) => {
        if (typeof data === 'number') {
            this.tree = new Tree([], []);
        } else {
            this.tree = DisplayConverter.jsonToDisplay(data);
        }
      }
    );
  }

}
