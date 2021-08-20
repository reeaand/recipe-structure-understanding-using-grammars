import {Injectable} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {Original} from '../models/original.model';
import {Observable} from 'rxjs';
import {REQUEST_HEADERS, SERVER_URL} from '../utils/http.utils';

@Injectable({
  providedIn: 'root'
})
export class RecipeService {

  constructor(public http: HttpClient) {

  }

  /**
   * Request the recipe from the server
   * @param recipe recipe text
   */
  public getJSON(recipe: string): Observable<Original | number>{
    return this.http.post<Original | number>(SERVER_URL + '/recipe', {sentence: recipe}, REQUEST_HEADERS);
  }
}
