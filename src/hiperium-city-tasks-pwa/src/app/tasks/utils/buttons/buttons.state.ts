
export class ButtonsState {

  private creatingState = false;
  private updatingState = false;

  public isCreatingState(): boolean {
    return this.creatingState;
  }

  public isUpdatingState(): boolean {
    return this.updatingState;
  }

  protected setCreateButtonsState(): void {
    this.creatingState = true;
    this.updatingState = false;
  }

  protected setUpdateButtonsState(): void {
    this.creatingState = false;
    this.updatingState = true;
  }
}
