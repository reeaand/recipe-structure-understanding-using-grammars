import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TreeDisplayComponent } from './tree-display.component';

describe('TreeDisplayComponent', () => {
  let component: TreeDisplayComponent;
  let fixture: ComponentFixture<TreeDisplayComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TreeDisplayComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(TreeDisplayComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
